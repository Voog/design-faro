<!DOCTYPE html>
{% include "template-settings" %}
{% include "template-variables" %}
<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" -%}
    {%- include "template-styles" -%}
  </head>
  <body class="front-page body-bg-picker-area js-background-type {{ body_bg_type }}">
    <div class="body-bg-color js-background-color"></div>
    <button
      class="voog-bg-picker-btn bg-picker {{ body_bg_key }}-picker"
      data-bg_key="{{ body_bg_key }}"
      data-type_picture="false"
      data-type_color="true"
      data-color_elem=".body-bg-color"
      data-picker_area_elem=".body-bg-picker-area"
      data-picker_elem =".{{ body_bg_key }}-picker"
      data-bg-color="{{ body_bg_color }}"
    ></button>
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
