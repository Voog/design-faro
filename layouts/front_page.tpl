{%- comment -%}
Possible front page layouts: "split" (default), "column" and "column-split".
Layout is applied by assigning according classname to "front-page-container" element.
{%- endcomment -%}
<!DOCTYPE html>
{% include "template-settings" %}
{% include "template-variables" %}
<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" -%}
    {%- include "template-styles" -%}
  </head>
  <body class="front-page full-height-body body-bg-picker-area js-background-type {{ body_bg_type }}">
    {% include "header" %}
    <div class="body-bg-color js-background-color"></div>
    <main class="front-page-content {{ front_page_layout }}" role="main" data-search-indexing-allowed="true">
      {%- if editmode -%}
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
      {%- endif -%}
      <div class="hero">
        <div class="content-formatted">
          {% content name="front-page-hero" %}
        </div>
      </div>
      <div class="split-section">
        <div class="section">
          <div class="content-formatted">
            {% content %}
          </div>

          <div class="content-formatted">
            {% content name="column-right" %}
          </div>
        </div>

        <div class="image-section">
        </div>
      </div>
    </main>

    {%- include "javascripts" -%}
  </body>
</html>
