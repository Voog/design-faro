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
      {% for block in body_blocks %}
        {% include "category",
          id: block.key,
          background: block.background
        %}
      {% endfor %}
    </main>

    {% include "footer" %}

    {% include "javascripts" %}

    <script>
      if (site) {
        site.handleCategoriesPageContent();
      }
    </script>
  </body>
</html>
