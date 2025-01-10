{% comment %}
  Expected parameters:
  - menuitem (MenuItem): The menuitem to display and render children for.
  - toplevel (Boolean): Whether the menuitem is a top-level item or not.
{% endcomment %}

<div class="menu-item-wrapper{% if editmode or menuitem.children? %} has-children{% endif %}{% if toplevel %} top-level{% else %} menu-child{% endif %}">
  {%- menulink menuitem wrapper-tag="div" wrapper-class="menu-item" %}

  {%- if menuitem.children? or editmode and menuitem.translated? %}
    <div class="menu-item-children">
      {%- for child in menuitem.visible_children %}
        {% include "menu-main-item" menuitem: child, toplevel: false %}
      {%- endfor %}

      {%- if editmode %}
        {%- if menuitem.hidden_children.size > 0 %}
          <div class="menu-child">
            {% menubtn menuitem.hidden_children %}
          </div>
        {%- endif %}

        <div class="menu-child">
          {% menuadd parent=menuitem %}
        </div>
      {% endif %}
    </div>
    <svg width="24" height="24" class="menu-children-icon">
      <use href="#ico-arrow-left"></use>
    </svg>
  {%- endif -%}
</div>
