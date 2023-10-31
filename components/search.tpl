<div class="search-wrapper js-search">
  <div class="search-close js-search-modal-close-btn"></div>
  <div class="search-inner">
    <form id="search" class="search-form js-search-form" method="get" action="#">
      <div class="search-input-wrapper">
        <input
          id="onpage_search"
          class="search-input"
          type="text"
          name=""
          placeholder="{{ "search" | lc | escape_once }}"
        >
      </div>
    </form>
    <div class="search-results js-voog-search-modal-inner"></div>
  </div>
</div>
