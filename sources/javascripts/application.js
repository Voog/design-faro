(function ($) {
  // ===========================================================================
  // Binds site search functionality.
  // ===========================================================================
  var bindSiteSearch = function (searchForm, languageCode, noResultsString) {
    if (searchForm) {
      const search = new VoogSearch(searchForm, {
        // This defines the number of results per query.
        per_page: 10,
        // Language code for restricting the search to page language.
        lang: languageCode,
        // If given, an DOM element results are rendered inside that element
        resultsContainer: $('.js-voog-search-modal-inner').get(0),
        // Defines if modal should close on sideclick.
        sideclick: false,
        // Mobile checkpoint
        mobileModeWidth: 900,
        // Updates results on every keypress.
        updateOnKeypress: true,
        // String for feedback if no results are found.
        noResults: noResultsString,
      });

      $(searchForm).on('sitesearch:showmodal', () => {
        if ($(window).width() <= 900) {
          $('.js-menu-main').addClass('search-modal-active');
        }
      });

      $(searchForm).on('sitesearch:hidemodal', () => {
        if ($(window).width() <= 900) {
          $('.js-menu-main').removeClass('search-modal-active');
        }
      });
    }
  };

  // Function to limit the rate at which a function can fire.
  const debounce = (func, wait, immediate) => {
    let timeout;

    return function () {
      const context = this,
        args = arguments;
      let later = function () {
        timeout = null;
        if (!immediate) func.apply(context, args);
      };
      let callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) {
        func.apply(context, args);
      }
    };
  };

  const bindSideClicks = () => {
    $('.container').on('mousedown', function (event) {
      if (!$(event.target).closest('.js-prevent-sideclick').length) {
        $('.js-popover').removeClass('expanded');
        $('.js-search-close-btn').trigger('click');
        $('.js-image-settings-popover').toggleClass('active');
      }
    });
  };

  const handleMenuContent = () => {
    const $mainMenu = $('.js-menu-main');
    const $dropdownMenu = $mainMenu.find('.dropdown-menu, .dropdown-menu-visible');
    const $dropdownContent = $dropdownMenu.find('.dropdown-menu-children');

    const $menu = $mainMenu.find('.menu').append($dropdownContent.children());
    const $menuItems = $menu.find('.menu-item-wrapper.top-level');
    const items = [];

    $dropdownMenu.removeClass('dropdown-menu-visible').addClass('dropdown-menu');

    $menuItems.each((idx, item) => {
      const isOverflowing = item.offsetTop > 0;

      // Make sure that atleast 1 menu element is visible in addition to dropdown icon
      if (idx >= 1 && isOverflowing) {
        // Push last visible item to dropdown to make room for dropdown icon
        if (items.length === 0 && idx >= 2) {
          items.push($($menuItems[idx - 1]));
        }
        items.push($(item));
      }
    });

    if (items.length > 0) {
      $dropdownContent.append(items);
      $dropdownMenu.append($dropdownContent);
      $menu.append($dropdownMenu);
      $dropdownMenu.removeClass('dropdown-menu').addClass('dropdown-menu-visible');
    }
  };

  const handleMobileMenuContent = () => {
    const $menu = $('.js-menu-main .menu');
    const $menuItems = $menu.find('.menu-item-wrapper.top-level:not(.menu-lang-wrapper)');

    $menuItems.each((_, item) => {
      $menu.append($(item));
    });
  };

  const buildCustomShoppingCartIcon = () => {
    // Emitted when the shopping cart button element is added to the DOM.
    $(document).on('voog:shoppingcart:button:created', () => {
      const itemsCount = getCartItemsCount();
      if (itemsCount >= 1) {
        $('.cart-btn').addClass('active');

        $('.js-cart-items-count').each((_, el) => $(el).text(itemsCount));
      }
    });
  };

  const getCartItemsCount = () => {
    const shoppingCart = Voog.ShoppingCart;

    return shoppingCart
      ? shoppingCart.getContents().items.reduce((acc, item) => acc + item.quantity, 0)
      : 0;
  };

  const handleProductCountChange = (e, addProduct) => {
    const itemsCount = getCartItemsCount();
    const $cartBtn = $('.cart-btn');
    const $counterElements = $('.js-cart-items-count');
    const prevCount = parseInt($('.cart-btn .js-cart-items-count').text()) || 0;
    const isCartModalOpen = $('.edy-ecommerce-modal-open').length >= 1;
    let timer;

    if (itemsCount >= 1 || addProduct) {
      if (timer != null) {
        clearTimeout(timer);
      }

      if (itemsCount > prevCount && !isCartModalOpen) {
        const currentLanguage = $('html').attr('lang');
        let productName = e.detail.product_name;

        if (
          Object.prototype.hasOwnProperty.call(e.detail, 'translations') &&
          Object.prototype.hasOwnProperty.call(e.detail.translations, 'name') &&
          Object.prototype.hasOwnProperty.call(e.detail.translations.name, currentLanguage)
        ) {
          productName = e.detail.translations.name[currentLanguage];
        }

        $('.cart-popover .product-name').text(productName);
        $(':not(body.edy-ecommerce-modal-open) .cart-popover').addClass('visible');

        timer = setTimeout(function () {
          $('.cart-popover').removeClass('visible');
        }, 3000);
      }

      $cartBtn.addClass('active');
      $counterElements.each((_, el) => $(el).text(itemsCount));
    } else {
      $cartBtn.removeClass('active');
      $counterElements.each((_, el) => $(el).text(''));
    }
  };

  const handleProductCountSync = () => {
    const itemsCount = getCartItemsCount();
    const $cartBtn = $('.cart-btn');
    const $counterElements = $('.js-cart-items-count');

    if (itemsCount >= 1) {
      $cartBtn.addClass('active');
      $counterElements.each((_, el) => $(el).text(itemsCount));
    } else {
      $cartBtn.removeClass('active');
      $counterElements.each((_, el) => $(el).text(''));
    }
  };

  const handleShoppingCartEvents = () => {
    // Emitted when a product is removed from the shopping cart
    $(document).on('voog:shoppingcart:removeproduct', e => {
      handleProductCountChange(e, false);
    });

    // Emitted when a product's quantity changes
    $(document).on('voog:shoppingcart:changequantity', e => {
      handleProductCountChange(e, true);
    });

    // Emitted when a new product is added to the cart
    $(document).on('voog:shoppingcart:addproduct', e => {
      handleProductCountChange(e, true);
    });

    $(document).on('voog:shoppingcart:contentschanged', () => {
      handleProductCountSync();
    });

    $('.cart-btn, .cart-popover').click(() => {
      if (getCartItemsCount() >= 1) {
        Voog.ShoppingCart.showCart();
      }
    });
  };

  const handleHeaderContent = callback => {
    const $header = $('.js-header .wrapper');
    const $headerRight = $header.find('.header-right');
    const $menuMain = $header.find('.js-menu-main .menu');

    if ($(window).width() > 900) {
      $header.append($headerRight);
    } else {
      $menuMain.append($headerRight);
    }

    callback();
  };

  const handleMenus = () => {
    if ($(window).width() > 900) {
      handleMenuContent();
    } else {
      handleMobileMenuContent();
    }
  };

  const setHeaderHeight = () => {
    $(':root').css('--header-height', `${$('.js-header').height()}px`);
  };

  const handleSearchPosition = () => {
    const $search = $('.search');

    if ($(window).width() > 900) {
      $('.header-right').prepend($search);
    } else {
      $('.menu').prepend($search);
    }
  };

  const bindMobileMenuBtnClick = () => {
    $('.js-menu-main .mobile-menu-button').click(() => {
      if ($('.js-header').hasClass('menu-active')) {
        $('.js-header').removeClass('menu-children-active menu-active');
        $('.js-header .menu-item-wrapper.has-children').removeClass('active');

        setTimeout(() => {
          $('.js-header .menu-item-children').removeClass('active');
        }, 1000);
      } else {
        $('.js-header').addClass('menu-active');
      }
    });

    $(
      '.js-menu-main .menu-children-icon, .menu-lang .menu-item, .menu-lang .menu-children-icon'
    ).click(e => {
      $(e.target).closest('.menu-item-wrapper.has-children').addClass('active');

      $(e.target)
        .parents('.menu-item-wrapper.has-children')
        .find('.menu-item-children:not(.active)')
        .first()
        .addClass('active');

      $('.js-header').addClass('menu-children-active');

      // Scroll menu to top when opening menu children
      $('.js-menu-main .menu').scrollTop(0);
    });

    $('.menu-lang .menu-children-icon').click(() => {
      $('.header-right').addClass('active');
    });

    $('.js-header .menu-children-close-icon').click(() => {
      const $lastActiveMenu = $('.menu-item-wrapper.has-children.active').last();

      $lastActiveMenu.removeClass('active');
      $lastActiveMenu.find('.menu-item-children').removeClass('active');

      if ($lastActiveMenu.hasClass('top-level')) {
        $('.js-header').removeClass('menu-children-active');

        setTimeout(() => {
          $('.header-right').removeClass('active');
        }, 1000);
      }
    });
  };

  const bindSearchBtnClick = () => {
    $('.js-search-modal-open-btn').click(() => {
      $('.js-search').addClass('active');
    });

    $('.js-search-modal-close-btn').click(() => {
      $('.js-search').removeClass('active');
    });
  };

  const handleBlockVisibility = () => {
    const blocks = document.querySelectorAll('.js-animated-block');

    if (blocks.length > 0) {
      const observer = new IntersectionObserver(
        entries => {
          entries.forEach(entry => {
            if (entry.isIntersecting) {
              entry.target.classList.add('visible');
            }
          });
        }
      );

      blocks.forEach(block => {
        observer.observe(block);
      })
    }
  }

  const handleWindowResize = () => {
    let prevWindowWidth = $(window).width();

    $(window).on('load', () => {
      handleMenus();
      handleSearchPosition();
      handleHeaderContent(setHeaderHeight);

      $('.js-menu-main, .js-header-right').removeClass('hidden');
    });

    $(window).resize(() => {
      const newWindowWidth = $(window).width();

      if (newWindowWidth !== prevWindowWidth) {
        $('.js-menu-main, .js-header-right').addClass('hidden');
      }
    });

    $(window).resize(
      debounce(() => {
        const newWindowWidth = $(window).width();

        if (newWindowWidth !== prevWindowWidth) {
          handleMenus();
          handleSearchPosition();
          handleHeaderContent(setHeaderHeight);

          $('.js-menu-main, .js-header-right').removeClass('hidden');

          prevWindowWidth = newWindowWidth;
        }
      }, 250)
    );
  };

  const init = () => {
    bindSideClicks();
    handleWindowResize();
    handleShoppingCartEvents();
    buildCustomShoppingCartIcon();
    bindMobileMenuBtnClick();
    bindSearchBtnClick();

    $(window).ready(() => {
      if (window.VoogEcommerce && !window.VoogEcommerce.storeInfo.is_publicly_unavailable) {
        $('.cart-btn').css('display', 'flex');
      }
    });
  };

  window.site = $.extend(window.site || {}, {
    bindSiteSearch: bindSiteSearch,
    handleBlockVisibility: handleBlockVisibility,
  });

  init();
})(jQuery);
