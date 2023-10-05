<nav class="menu-main js-menu-main">
  <div class="menu">
    {% unless site.root_item.hidden? -%}
      <div class="menu-item-wrapper">
        {% menulink site.root_item wrapper-tag="div" wrapper-class="menu-item" %}
      </div>
    {%- endunless %}

    {% for item in site.visible_menuitems %}
      <div class="menu-item-wrapper">
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
        {%- endif -%}
      </div>
    {%- endfor -%}
    <div class="dropdown-menu">
      {% include "ico-ellipsis" classname: "dropdown-menu-icon" %}
      <div class="dropdown-menu-children"></div>
    </div>
  </div>
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
</nav>
