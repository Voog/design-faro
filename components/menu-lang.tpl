<div class="menu-main menu-lang">
  <div class="menu-item-wrapper menu-lang-wrapper">
    {% for language in site.languages -%}
      {% if language.code == page.language_code %}
        <a
          href="{{ language.url }}"
          class="menu-item {% if language.selected? %}active{% endif %}"
          data-lang-code="{{ language.locale }}"
        >
          {{ language.title }}
        </a>
      {% endif %}
    {% endfor %}

    {% if site.has_many_languages? or editmode %}
      <div class="menu-item-children">
      {% for language in site.languages -%}
        {% unless language.code == page.language_code %}
          <a
            class="menu-child"
            href="{{ language.url }}"
            data-lang-code="{{ language.locale }}"
          >
            {{ language.title }}
          </a>
        {% endunless %}
      {%- endfor %}

      {% if editmode %}
        <span class="menu-child">
          {% languageadd %}
        </span>
      {% endif %}

      </div>
    {% endif %}
  </div>
</div>
