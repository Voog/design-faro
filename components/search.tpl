<div class="search-wrapper js-search">
  <div class="search-close js-search-modal-close-btn"></div>
  <div class="search-inner">
    <form id="search" class="search-form js-search-form" method="get">
      <div class="search-input-wrapper">
        <input
          id="onpage_search"
          class="search-input js-search-input"
          type="text"
          placeholder="{{ 'search' | lc | escape_once }}"
        >
      </div>
      {% comment %}
      TODO: Use localized translation
      {% endcomment %}
      <input type="reset" class="clear-search-button" value="Clear">
    </form>
    <div class="search-results js-voog-search-modal-inner"></div>
  </div>
</div>
