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
        sideclick: true,
        // Mobile checkpoint
        mobileModeWidth: 480,
        // Updates results on every keypress.
        updateOnKeypress: true,
        // String for feedback if no results are found.
        noResults: noResultsString,
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
    const $menuItems = $menu.find('.menu-item-wrapper');
    const items = [];

    $menuItems.each((idx, item) => {
      const isOverflowing =
        item.offsetHeight < item.scrollHeight || item.offsetWidth < item.scrollWidth;

      if (isOverflowing) {
        // Push last visible item to dropdown to make room for dropdown icon
        if (items.length === 0) {
          items.push($menuItems[idx - 1]);
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

  const buildCustomShoppingCartIcon = () => {
    // Emitted when the shopping cart button element is added to the DOM.
    $(document).on('voog:shoppingcart:button:created', () => {
      if (getCartItemsCount() >= 1) {
        $('.cart-btn').addClass('active');
        $('.cart-btn .cart-btn-count').text(getCartItemsCount());
      }
    });
  };

  const getCartItemsCount = () =>
    Voog.ShoppingCart.getContents().items.reduce((acc, item) => acc + item.quantity, 0);

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

    $categoriesPageContent.css('height', 'calc(calc(100vh - 96px) - ' + headerHeight + 'px)');
  }

  const handleWindowResize = () => {
    $(document).ready(() => {
      handleMenuContent();
    });

    $(window).resize(
      debounce(() => {
        handleMenuContent();
      }, 250)
    );
  };

  const init = () => {
    bindSideClicks();
    handleWindowResize();
    handleShoppingCartEvents();
    buildCustomShoppingCartIcon();
  };

  window.site = $.extend(window.site || {}, {
    bindSiteSearch: bindSiteSearch,
    handleCategoriesPageContent: handleCategoriesPageContent,
  });

  init();
})(jQuery);
