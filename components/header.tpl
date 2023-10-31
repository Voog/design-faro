{% include "cart-popover" %}

<div class="header-wrapper js-header{% if fixed %} fixed{% endif %}">
  <div class="header">
    {% include "menu-main" %}

    <div class="header-content">
      {% xcontent name="header" %}
    </div>

    <div class="header-right">
      <div class="search">
        <span class="search-button js-search-modal-open-btn">
          {{ "search" | lce | escape_once }}
        </span>
        {%- include "search" -%}
      </div>
      {% include "menu-lang" %}
      <span class="cart-btn">
        {% comment %}
          TODO: Use localized translation
        {% endcomment %}
        Cart
        <span class="cart-btn-count"></span>
      </span>
    </div>
  </div>
</div>
