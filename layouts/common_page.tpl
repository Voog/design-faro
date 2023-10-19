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
      {% for block_data in common_page_blocks %}
        {%- assign block_key = block_data[0] -%}
        {%- assign block_value = block_data[1] -%}
        {% include "block",
          id: block_key,
          layout: block_value.layout,
          background: block_value.background
        %}
      {% endfor %}
    </main>

    {%- include "javascripts", blocks_data: common_page_blocks -%}
  </body>
</html>
