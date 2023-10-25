{% assign id = block_data.key %}
{% assign content_area_count = layout_data.content_areas | default: 1 %}

{%- capture move_buttons -%}
  <div class="move-buttons">
    <button
      class="move-button"
      data-key="{{ id }}"
      data-direction="up"
      data-wrapper-class="{{ wrapper_class }}"
    >
      Up
    </button>
    <button
      class="move-button"
      data-key="{{ id }}"
      data-direction="down"
      data-wrapper-class="{{ wrapper_class }}"
    >
      Down
    </button>
  </div>
{%- endcapture -%}

<div
  class="block-wrapper{% if wrapper_class %} {{ wrapper_class }}{% endif %}"
  data-block-key="{{ id }}"
>
  {{ move_buttons }}

  {% if layout_data.separate_bg_pickers == true %}
    {% for index in (1..content_area_count) %}
      {% assign background_key =
        "block_"
        | append: id
        | append: "_col_"
        | append: index
        | append: "_background"
      %}
      {% assign background = block_data[background_key] %}

      {% include "block-structure",
        background: background,
        background_key: background_key,
        block_index: index,
        content_area_count: 1,
        content_class_name: content_class_name,
        id: id,
        layout_name: layout_name,
        separate_bg_pickers: layout_data.separate_bg_pickers
      %}
    {% endfor %}
  {% else %}
    {% assign background_key =
      "block_"
      | append: id
      | append: "_col_1_background"
    %}

    {% assign background = block_data[background_key] %}

    {% include "block-structure",
      background: background,
      background_key: background_key,
      content_area_count: content_area_count,
      content_class_name: content_class_name,
      id: id,
      layout_name: layout_name,
      separate_bg_pickers: layout_data.separate_bg_pickers
    %}
  {% endif %}
</div>
