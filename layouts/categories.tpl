<!DOCTYPE html>
{% include "template-settings" %}
{% include "template-variables" %}
<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" -%}
    {%- include "template-styles" -%}
  </head>

  <body class="categories-page full-height-body">
    {% include "header" %}

    <main class="categories-page-content">
      {% for section in categories_page_sections %}
        {%- assign section_id = section[0] -%}
        {%- assign section_data = section[1] -%}

        {% include "category",
          id: section_id,
          background: section_data.background
        %}
      {% endfor %}
    </main>
    {%- include "javascripts", blocks_data: categories_page_sections -%}

    <script>
      if (site) {
        site.handleCategoriesPageContent();
      }
    </script>
  </body>
</html>
