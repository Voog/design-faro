{% assign bg_color = background.color %}
{% assign bg_image = background.image %}

{%- if bg_color == blank -%}
  {%- assign bg_color = "none" -%}
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
    --{{ background_key }}-bg-color: {{ bg_color }};
    --{{ background_key }}-bg-color-rgb:  {{- bg_color.r | default: 255 -}},
                                          {{- bg_color.g | default: 255 -}},
                                          {{- bg_color.b | default: 255 -}};
  }

  .{{ background_key }}-bg-color {
    background-color: var(--{{ background_key }}-bg-color);
  }

  .{{ background_key }}-background-image {
    background-image: url("{{ background.image }}");
  }
</style>

<div
  class="
    block
    {{ layout_name }}
    bg-picker-area
    {{ background_key }}-picker-area
    js-background-type
    {{ bg_type }}
    {% if content_class_name -%}{{ content_class_name }}{%- endif -%}
  "
  data-block-key="{{ id }}"
>
  <div class="block-bg-color {{ background_key }}-bg-color js-background-color"></div>
  <div class="block-bg-image {{ background_key }}-background-image js-background-image"></div>

  {%- if editmode -%}
    <button
      class="voog-bg-picker-btn bg-picker {{ background_key }}-picker"
      data-bg_key="{{ body_blocks_key }}"
      data-block_key="{{ id }}"
      data-data_key="{{ background_key }}"
      data-type_picture="true"
      data-type_color="true"
      data-color_elem=".{{ background_key }}-bg-color"
      data-picker_area_elem=".{{ background_key }}-picker-area"
      data-picker_elem =".{{ background_key }}-picker"
      data-bg-color="{{ bg_color }}"
      data-variable_name="{{ background_key }}-bg-color"
    ></button>
  {%- endif -%}
  <div class="wrapper">
    {% if separate_bg_pickers %}
      {%- assign content_area_name = "block-" | append: id | append: "-col-" | append: block_index -%}

      <div class="content-formatted">
        {% content name=content_area_name %}
      </div>
    {% else %}
      {%- for index in (1..content_area_count) -%}
        {%- assign content_area_name = "block-" | append: id | append: "-col-" | append: index -%}

        <div class="content-formatted">
          {% content name=content_area_name %}
        </div>
      {%- endfor -%}
    {% endif %}
  </div>
</div>
