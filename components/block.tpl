{% assign id = block_data.key %}
{% assign content_area_count = layout_data.content_areas | default: 1 %}

{% comment %}
TODO: Figure out editmode design
{% endcomment %}

{%- capture move_buttons -%}
  <div class="move-buttons">
    <button
      class="move-button js-move-button"
      data-key="{{ id }}"
      data-direction="up"
      data-wrapper-class="{{ wrapper_class }}"
    >
      Up
    </button>
    <button
      class="move-button js-move-button"
      data-key="{{ id }}"
      data-direction="down"
      data-wrapper-class="{{ wrapper_class }}"
    >
      Down
    </button>
  </div>
{%- endcapture -%}

{%- capture delete_button -%}
  <button
    class="delete-button js-delete-button"
    data-key="{{ id }}"
    data-wrapper-class="{{ wrapper_class }}"
  >
    Delete
  </button>
{%- endcapture -%}

{%- capture change_layout_buttons -%}
  <div>
    Current layout: {{ layout_name }}<br>
    Change layout <br>
    {% for layout in allowed_layouts %}
      {% unless layout == layout_name %}
        <button
          class="js-change-layout-button"
          data-key="{{ id }}"
          data-layout="{{ layout }}"
        >
          {{ layout }}
        </button>
      {% endunless %}
    {% endfor %}
  </div>
{%- endcapture -%}

<div
  class="block-wrapper{% if wrapper_class %} {{ wrapper_class }}{% endif %}"
  data-block-key="{{ id }}"
>
  {% if editmode %}
    <div class="block-edit-buttons">
      {{ move_buttons }}
      {{ delete_button }}
      {{ change_layout_buttons }}
    </div>
  {% endif %}

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
        content_class: content_class,
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
      content_class: content_class,
      id: id,
      layout_name: layout_name,
      separate_bg_pickers: layout_data.separate_bg_pickers
    %}
  {% endif %}
</div>
