{% assign content_area_count = layout_data.content_areas | default: 1 %}

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

<style>
  :root {
    --block-{{ id }}-bg-color: {{ bg_color }};
    --block-{{ id }}-bg-color-rgb:  {{- bg_color.r | default: 255 -}},
                                    {{- bg_color.g | default: 255 -}},
                                    {{- bg_color.b | default: 255 -}};
  }

  .block-{{ id }}-bg-color {
    background-color: var(--block-{{ id }}-bg-color);
  }

  .block-{{ id }}-background-image {
    background-image: url("{{ background.image }}");
  }
</style>

<div class="block {{ layout_name }} bg-picker-area block-{{ id }}-picker-area js-background-type {{ bg_type }}">
  <div class="block-bg-color block-{{ id }}-bg-color js-background-color"></div>
  <div class="block-bg-image block-{{ id }}-background-image js-background-image"></div>

  {%- if editmode -%}
    <button
      class="voog-bg-picker-btn bg-picker block-{{ id }}-picker"
      data-bg_key="{{ body_blocks_key }}"
      data-data_key="{{ id }}"
      data-type_picture="true"
      data-type_color="true"
      data-color_elem=".block-{{ id }}-bg-color"
      data-picker_area_elem=".block-{{ id }}-picker-area"
      data-picker_elem =".block-{{ id }}-picker"
      data-bg-color="{{ bg_color }}"
      data-variable_name="block-{{ id }}-bg-color"
    ></button>
  {%- endif -%}
  <div class="wrapper{% if content_class_name %} {{ content_class_name }}{% endif %}">
    {%- for index in (1..content_area_count) -%}
      {%- assign content_area_name = "block-" | append: id | append: "col-" | append: index -%}

      <div class="content-formatted">
        {% content name=content_area_name %}
      </div>
    {%- endfor -%}
  </div>
</div>
