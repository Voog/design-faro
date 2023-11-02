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
      })

      $(searchForm).on('sitesearch:hidemodal', () => {
        if ($(window).width() <= 900) {
          $('.js-menu-main').removeClass('search-modal-active');
        }
      })
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
    const $menuItems = $menu.find('.menu-item-wrapper');
    const items = [];

    $menuItems.each((idx, item) => {
      const isOverflowing = item.offsetTop > 0;

      // Make sure that atleast 1 menu element is visuble in addition to dropdown icon
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
    const $menuItems = $menu.find('.menu-item-wrapper:not(.menu-lang-wrapper)');

    $menuItems.each((_, item) => {
      $menu.append($(item));
    });
  };

  const buildCustomShoppingCartIcon = () => {
    // Emitted when the shopping cart button element is added to the DOM.
    $(document).on('voog:shoppingcart:button:created', () => {
      if (getCartItemsCount() >= 1) {
        $('.cart-btn').addClass('active');
        $('.cart-btn .cart-btn-count').text(getCartItemsCount());
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
    const $counterElement = $('.cart-btn .cart-btn-count');
    const prevCount = parseInt($counterElement.text()) || 0;
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
      $counterElement.text(itemsCount);
    } else {
      $cartBtn.removeClass('active');
      $counterElement.text('');
    }
  };

  const handleProductCountSync = () => {
    const itemsCount = getCartItemsCount();
    const $cartBtn = $('.cart-btn');
    const $counterElement = $('.cart-btn .cart-btn-count');

    if (itemsCount >= 1) {
      $cartBtn.addClass('active');
      $counterElement.text(itemsCount);
    } else {
      $cartBtn.removeClass('active');
      $counterElement.text('');
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

  const handleCategoriesPageContent = () => {
    const headerHeight = $('.js-header').height();
    const $categoriesPageContent = $('.js-category-section');

    $categoriesPageContent.css('height', `calc(calc(100vh - ${headerHeight}px)`);
  };

  const handleHeaderContent = callback => {
    const $header = $('.js-header .header');
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

  const handleMenuPadding = () => {
    if ($(window).width() > 900) {
      $('.js-menu-main .menu .menu-item-wrapper').first().css('padding-top', '');
      $('.js-menu-main .menu-item-children, .menu-lang .menu-item-children').css('padding-top', '');
      $('.search').css('padding-top', '');
    } else {
      const headerHeight = $('.js-header').height();

      $('.js-menu-main .menu div:visible').first().css('padding-top', `${headerHeight}px`);
      $('.js-menu-main .menu-item-children').css('padding-top', `${headerHeight}px`);
    }
  };

  const handleSearchPosition = () => {
    const $search = $('.search');

    if ($(window).width() > 900) {
      $('.header-right').prepend($search)
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

    $('.js-menu-main .menu-children-icon, .menu-lang .menu-children-icon').click(
      e => {
        $(e.target).closest('.menu-item-wrapper.has-children').addClass('active');
        $(e.target.parentElement).find('.menu-item-children').addClass('active');
        $('.js-header').addClass('menu-children-active');

        // Scroll menu to top when opening menu children
        $('.js-menu-main .menu').scrollTop(0);
      }
    );

    $('.menu-lang .menu-children-icon').click(() => {
      $('.header-right').addClass('active');
    });

    $('.js-header .menu-children-close-icon').click(() => {
      $('.menu-item-wrapper.has-children').removeClass('active');
      $('.menu-item-children').removeClass('active');
      $('.js-header').removeClass('menu-children-active');

      setTimeout(() => {
        $('.header-right').removeClass('active');
      }, 1000);
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

  const handleWindowResize = () => {
    let prevWindowWidth = $(window).width();

    $(document).ready(() => {
      handleMenus();
      handleSearchPosition();
      handleHeaderContent(() => {
        handleMenuPadding();
        handleCategoriesPageContent();
      });
    });

    $(window).resize(
      debounce(() => {
        const newWindowWidth = $(window).width();

        if (newWindowWidth !== prevWindowWidth) {
          handleMenus();
          handleSearchPosition();
          handleHeaderContent(() => {
            handleMenuPadding();
          });

          prevWindowWidth = newWindowWidth;
        }
      }, 250)
    )
  };

  const init = () => {
    bindSideClicks();
    handleWindowResize();
    handleShoppingCartEvents();
    buildCustomShoppingCartIcon();
    bindMobileMenuBtnClick();
    bindSearchBtnClick();
  };

  window.site = $.extend(window.site || {}, {
    bindSiteSearch: bindSiteSearch,
  });

  init();
})(jQuery);
