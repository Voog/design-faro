<div class="cart-popover">
  <div class="wrapper">
    <div class="icon">
      {% include "ico-cart" %}
    </div>
    <div class="content">
      <div class="info">
        <span class="product-name"></span> {{ "was_added_to_cart" | lc | escape_once }}.
      </div>
      <div class="view-cart">{{ "view_cart" | lc | escape_once }}</div>
    </div>
  </div>
</div>
