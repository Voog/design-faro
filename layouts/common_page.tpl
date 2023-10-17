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
      <div class="top-content content-formatted">
        {% content %}
      </div>

      {% include "block", block_type: 1, block_id: 1 %}
      {% include "block", block_type: 2, block_id: 2 %}
      {% include "block", block_type: 3, block_id: 3 %}
      {% include "block", block_type: 4, block_id: 4 %}
    </main>
    {%- include "javascripts" -%}
  </body>
</html>
