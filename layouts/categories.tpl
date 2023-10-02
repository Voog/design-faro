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

    <main class="categories-page-content split-content">
      <div class="content-formatted">
        {% content name="categories-left" %}
      </div>
      <div class="content-formatted">
        {% content name="categories-right" %}
      </div>
    </main>
    {%- include "javascripts" -%}
  </body>
</html>
