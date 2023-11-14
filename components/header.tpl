{% include "cart-popover" %}

<header class="header js-header{% if fixed %} fixed{% endif %}">
  {% include "ico-arrow-left" classname: "ico-hidden" %}
  <div class="wrapper">
    {% include "menu-main" %}

    <div class="header-content content-formatted">
      {% xcontent name="header" %}
    </div>

    <div class="header-right">
      <div class="search">
        {% if site.search.enabled %}
          <span class="search-button js-search-modal-open-btn">
            {{ "search" | lc | escape_once }}
          </span>
          {%- include "search" -%}
        {% endif %}
      </div>

      {%- include "menu-lang" -%}

      <span class="cart-btn">
        {% comment %}
          TODO: Use localized translation
        {% endcomment %}
        Cart
        <span class="cart-btn-count"></span>
      </span>
    </div>
  </div>
</header>
