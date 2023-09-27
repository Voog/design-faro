<div class="menu-lang">
  {% for language in site.languages -%}
    <span>
      <a class="lang-flag lang-flag-{{ language.code }}{% if language.selected? %} active{% endif %}" href="{{ language.url }}" data-lang-code="{{ language.locale }}">{{ language.title }}</a>
    </span>
  {%- endfor %}

  {% if editmode -%}
    <span class="edit-btn">
      {% languageadd %}
    </span>
  {%- endif %}
</div>
