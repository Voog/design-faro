<svg width="32" height="32" viewBox="0 0 32 32" class="menu-children-close-icon">
  <use href="#ico-arrow-left"></use>
</svg>

{%- comment %}
  Menus are hidden initially to wait for finalized positioning with JS
{% endcomment -%}
<nav class="menu-main js-menu-main hidden">
  <div class="mobile-menu-button">
    <div class="stripe"></div>
    <div class="stripe"></div>
    <span class="cart-item-count js-cart-items-count"></span>
  </div>

  <div class="menu">
    {% unless site.root_item.hidden? -%}
      <div class="menu-item-wrapper top-level">
        {% menulink site.root_item wrapper-tag="div" wrapper-class="menu-item" %}
      </div>
    {%- endunless %}

    {% for item in site.visible_menuitems %}
      {% include "menu-main-item" menuitem: item, toplevel: true %}
    {%- endfor -%}

    {% if editmode -%}
      {%- if site.hidden_menuitems.size > 0 -%}
        <div class="menu-item-wrapper top-level">
          {% menubtn site.hidden_menuitems %}
        </div>
      {%- endif %}

      <div class="menu-item-wrapper top-level">
        {% menuadd %}
      </div>
    {% endif -%}
    <div class="dropdown-menu">
      {% include "ico-ellipsis" classname: "dropdown-menu-icon" %}
      <div class="dropdown-menu-children"></div>
    </div>
  </div>
</nav>
