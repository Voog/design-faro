<div class="menu-main menu-lang">
  <div class="
    menu-item-wrapper
    menu-lang-wrapper
    top-level
    {% if site.has_many_languages?%}has-children{% endif %}
  ">
    {% for language in site.languages -%}
      {% if language.code == page.language_code %}
        <span class="menu-item" data-lang-code="{{ language.locale }}">
          {{ language.title }}
        </span>
      {% endif %}
    {% endfor %}

    {% if site.has_many_languages? or editmode %}
      <div class="menu-item-children">
      {% for language in site.languages -%}
        {% unless language.code == page.language_code %}
          <div class="menu-item-wrapper menu-child">
            <a
              class="menu-item"
              href="{{ language.url }}"
              data-lang-code="{{ language.locale }}"
            >
              {{ language.title }}
            </a>
          </div>
        {% endunless %}
      {%- endfor %}

      {% if editmode %}
        <span class="menu-child">
          {% languageadd %}
        </span>
      {% endif %}

      </div>

      <svg width="24" height="24" class="menu-children-icon">
        <use href="#ico-arrow-left"></use>
      </svg>
    {% endif %}
  </div>
</div>
