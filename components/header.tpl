{% include "cart-popover" %}

<header class="header js-header{% if fixed %} fixed{% endif %}">
  {% include "ico-arrow-left" classname: "ico-hidden" %}
  <div class="wrapper">
    {% include "menu-main" %}

    <div class="header-content content-formatted">
      {% xcontent name="header" %}
    </div>

    {%- comment %}
      Right header content is hidden initially for menus to be positioned with JS
    {% endcomment -%}
    <div class="header-right js-header-right hidden">
      <div class="search">
        {% if site.search.enabled %}
          <span class="search-button js-search-modal-open-btn">
            {{ "search" | lc | escape_once }}
          </span>
          {%- include "search" -%}
        {% endif %}
      </div>

      {%- if site.has_many_languages? or editmode -%}
        {%- include "menu-lang" -%}
      {%- endif -%}

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
