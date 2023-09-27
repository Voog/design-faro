<nav class="menu-main">
  <ul class="menu">
    {% unless site.root_item.hidden? -%}
      {% menulink site.root_item wrapper-tag="li" %}
    {%- endunless %}

    {% for item in site.visible_menuitems %}
      {%- menulink item wrapper-tag="li" %}
      {%- if item.selected? %}
        {%- if item.children? %}
          <ul>
            {%- for child in item.visible_children %}
              {% menulink child wrapper-tag="li" %}
            {%- endfor %}
          </ul>
        {%- endif -%}
        {%- if editmode %}
          <ul>
            {%- if item.hidden_children.size > 0 %}
              <li>{% menubtn item.hidden_children %}</li>
            {%- endif %}
            <li>{% menuadd parent=item %}</li>
          </ul>
        {% endif %}
      {%- endif -%}
    {%- endfor -%}
  </ul>
  {% if editmode -%}
    <ul class="menu">
      {%- if site.hidden_menuitems.size > 0 -%}
        <li>{% menubtn site.hidden_menuitems %}</li>
      {%- endif %}

      <li>{% menuadd %}</li>
    </ul>
  {% endif -%}
</nav>
