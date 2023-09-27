<!DOCTYPE html>
{%- include "template-settings" -%}
<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" -%}
  </head>
  <body>
    <div class="container-wrap">
      {% include "header" %}

      <div class="container">
        <main class="content" role="main" data-search-indexing-allowed="true">
          <div class="content-formatted">
            {% content %}
          </div>
        </main>
      </div>
    </div>

    {%- include "javascripts" -%}
  </body>
</html>
