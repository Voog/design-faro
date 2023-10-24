{% assign bg_color = background.color %}
{% assign bg_image = background.image %}
{%- if bg_color == blank -%}
  {%- assign bg_color = 'none' -%}
{%- endif -%}

{% assign bg_color_data = background.colorData %}
{% assign bg_combined_lightness = background.combinedLightness %}

{% if background %}
  {% if bg_combined_lightness %}
    {% if bg_combined_lightness > 0.6 %}
      {% assign bg_type = "light-background" %}
    {% else %}
      {% assign bg_type = "dark-background" %}
    {% endif %}
  {% else %}
    {% if bg_color_data.a >= 0.6 %}
      {% if bg_color_data.lightness >= 0.6 %}
        {% assign bg_type = "light-background" %}
      {% else %}
        {% assign bg_type = "dark-background" %}
      {% endif %}
    {% else %}
      {% assign bg_type = "light-background" %}
    {% endif %}
  {% endif %}
{% else %}
  {% assign bg_type = "light-background" %}
{% endif %}

{%- assign content_name = "categories-content-" | append: id -%}

<div class="category-section bg-picker-area category-{{ id }}-picker-area js-background-type {{ bg_type }}">
  <style>
    :root {
      --category-{{ id }}-bg-color: {{ bg_color }};
      --category-{{ id }}-bg-color-rgb: {{- bg_color.r | default: 255 -}},
                                        {{- bg_color.g | default: 255 -}},
                                        {{- bg_color.b | default: 255 -}};
    }

    .category-{{ id }}-bg-color {
      background-color: var(--category-{{ id }}-bg-color);
    }

    .category-{{ id }}-background-image {
      background-image: url("{{ background.image }}");
    }
  </style>

  <div class="category-bg-color category-{{ id }}-bg-color js-background-color"></div>
  <div class="category-bg-image category-{{ id }}-background-image js-background-image"></div>

  {%- if editmode -%}
    <button
      class="voog-bg-picker-btn bg-picker cateogry-{{ id }}-picker"
      data-bg_key="{{ body_blocks_key }}"
      data-data_key="{{ id }}"
      data-type_picture="true"
      data-type_color="true"
      data-color_elem=".category-{{ id }}-bg-color"
      data-picker_area_elem=".category-{{ id }}-picker-area"
      data-picker_elem =".category-{{ id }}-picker"
      data-bg-color="{{ bg_color }}"
      data-bg-image="{{ bg_image }}"
      data-variable_name="category-{{ id }}-bg-color"
    ></button>
  {%- endif -%}

  <div class="content-formatted js-category-section">
    {% content name=content_name %}
  </div>
</div>
