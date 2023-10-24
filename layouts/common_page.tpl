<!DOCTYPE html>
{% include "template-settings" %}
{% include "template-variables" %}
<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" -%}
    {%- include "template-styles" -%}
  </head>

  <body class="common-page">
    {% include "header" %}

    <main class="common-page-content" role="main" data-search-indexing-allowed="true">
      {% for block_data in body_blocks %}
        {% include "block",
          id: block_data.key,
          layout: block_data.layout,
          background: block_data.background
        %}
      {% endfor %}
    </main>

    {% include "footer" %}

    {% include "javascripts", blocks_data: body_blocks %}
  </body>
</html>
