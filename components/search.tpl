<div class="search-wrapper js-search">
  <div class="search-close js-search-modal-close-btn"></div>
  <div class="search-inner">
    <form id="search" class="search-form js-search-form" method="get">
      {% include "ico-search" %}
      <div class="search-input-wrapper">
        <input
          id="onpage_search"
          class="search-input js-search-input"
          type="text"
          placeholder="{{ 'search' | lc | escape_once }}"
        >
      </div>
      <input type="reset" class="clear-search-button" value="{{ 'clear' | lc | escape_once }}">
    </form>
    <div class="search-results js-voog-search-modal-inner"></div>
  </div>
</div>
