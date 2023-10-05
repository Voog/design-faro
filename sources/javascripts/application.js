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
    console.log('running');
    var $mainMenu = $('.js-menu-main');
    var $dropdownMenu = $mainMenu.find('.dropdown-menu, .dropdown-menu-visible');
    var $dropdownContent = $dropdownMenu.find('.dropdown-menu-children');

    var $menu = $mainMenu.find('.menu').append($dropdownContent.children());
    var $menuItems = $menu.find('.menu-item-wrapper');
    var items = [];

    $menuItems.each(function (idx, item) {
      var isOverflowing =
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
      $dropdownMenu.removeClass('dropdown-menu').addClass('dropdown-menu-visible')
    }
  };

  const handleWindowResize = () => {
    $(document).ready(function () {
      handleMenuContent();
    });

    $(window).resize(debounce(function () {
      handleMenuContent();
    }, 250));
  }

  const init = () => {
    bindSideClicks();
    handleWindowResize();
  };

  window.site = $.extend(window.site || {}, {
    bindSiteSearch: bindSiteSearch,
  });

  init();
})(jQuery);
