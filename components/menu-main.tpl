<svg width="32" height="32" viewBox="0 0 32 32" class="menu-children-close-icon">
  <use href="#ico-arrow-left"></use>
</svg>

<nav class="menu-main js-menu-main">
  <div class="mobile-menu-button">
    <div class="stripe"></div>
    <div class="stripe"></div>
  </div>

  <div class="menu">
    {% unless site.root_item.hidden? -%}
      <div class="menu-item-wrapper">
        {% menulink site.root_item wrapper-tag="div" wrapper-class="menu-item" %}
      </div>
    {%- endunless %}

    {% for item in site.visible_menuitems %}
      <div class="menu-item-wrapper{% if item.children? %} has-children{% endif %}">
        {%- menulink item wrapper-tag="div" wrapper-class="menu-item" %}

        {%- if item.children? %}
          <div class="menu-item-children">
            {%- for child in item.visible_children %}
              {% menulink child wrapper-tag="div" wrapper-class="menu-child" %}
            {%- endfor %}

            {%- if editmode %}
              {%- if item.hidden_children.size > 0 %}
                <div class="menu-child">
                  {% menubtn item.hidden_children %}
                </div>
              {%- endif %}

              <div class="menu-child">
                {% menuadd parent=item %}
              </div>
            {% endif %}
          </div>
          <svg width="24" height="24" class="menu-children-icon">
            <use href="#ico-arrow-left"></use>
          </svg>
        {%- endif -%}
      </div>
    {%- endfor -%}

    {% if editmode -%}
      {%- if site.hidden_menuitems.size > 0 -%}
        <div class="menu-item-wrapper">
          {% menubtn site.hidden_menuitems %}
        </div>
      {%- endif %}

      <div class="menu-item-wrapper">
        {% menuadd %}
      </div>
    {% endif -%}
    <div class="dropdown-menu">
      {% include "ico-ellipsis" classname: "dropdown-menu-icon" %}
      <div class="dropdown-menu-children"></div>
    </div>
  </div>
</nav>
