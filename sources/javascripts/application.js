(function ($) {
  // ===========================================================================
  // Binds site search functionality.
  // ===========================================================================
  const bindSiteSearch = (searchForm, languageCode, noResultsString) => {
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

  const init = () => {
    bindSideClicks();
  };

  window.site = $.extend(window.site || {}, {
    bindSiteSearch: bindSiteSearch,
  });

  init();
})(jQuery);
