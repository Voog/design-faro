{% assign left_content_name = "block-content-left-" | append: id %}
{% assign right_content_name = "block-content-right-" | append: id %}

{%- capture block_content_html -%}
  {%- unless editmode -%}
    {%- content name=left_content_name -%}
    {%- content name=right_content_name -%}
  {%- endunless -%}
{%- endcapture -%}

{%- capture block_content_size -%}
  {{- block_content_html | size | minus: 1 -}}
{%- endcapture -%}

{%- assign block_has_content = false -%}

{%- unless block_content_size contains "-" -%}
  {%- assign block_has_content = true -%}
{%- endunless -%}

{% assign bg_color = background.color %}
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

{% if editmode or block_has_content -%}
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
  </style>

  <div class="block block-{{ layout }} bg-picker-area block-{{ id }}-picker-area js-background-type {{ bg_type }}">
    <div class="block-bg-color block-{{ id }}-bg-color js-background-color"></div>
    {%- if editmode -%}
      <button
        class="voog-bg-picker-btn bg-picker block-{{ id }}-picker"
        data-bg_key="{{ body_blocks_key }}"
        data-data_key="{{ id }}"
        data-type_picture="false"
        data-type_color="true"
        data-color_elem=".block-{{ id }}-bg-color"
        data-picker_area_elem=".block-{{ id }}-picker-area"
        data-picker_elem =".block-{{ id }}-picker"
        data-bg-color="{{ bg_color }}"
        data-variable_name="block-{{ id }}-bg-color"
      ></button>
    {%- endif -%}
    <div class="wrapper">
      <div class="content-formatted">
        {% content name=left_content_name %}
      </div>
      <div class="content-formatted">
        {% content name=right_content_name %}
      </div>
    </div>
  </div>
{% endif -%}
