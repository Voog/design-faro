{%- assign id = block_data.key -%}
{%- assign content_area_count = layout_data.content_areas | default: 1 -%}

{%- capture move_buttons -%}
  <button
    class="move-button up-button js-move-button"
    data-title="{{ 'move_block_up' | lce }}"
    data-key="{{ id }}"
    data-direction="up"
    data-wrapper-class="{{ wrapper_class }}"
  ></button>
  <button
    class="move-button down-button js-move-button"
    data-title="{{ 'move_block_down' | lce }}"
    data-key="{{ id }}"
    data-direction="down"
    data-wrapper-class="{{ wrapper_class }}"
  ></button>
{%- endcapture -%}

{%- capture delete_button -%}
  <button
    class="delete-button js-delete-button"
    data-title="{{ 'delete_block' | lce }}"
    data-key="{{ id }}"
    data-wrapper-class="{{ wrapper_class }}"
  ></button>
{%- endcapture -%}

{%- capture change_layout_options -%}
  {%- if allowed_layouts.size > 1 -%}
    <div class="change-layout-options" data-title="{{ 'change_content_layout' | lce }}">
      <select class="js-change-layout-select">
        {% for layout in allowed_layouts %}
          <option
            class="js-change-layout-button"
            data-key="{{ id }}"
            value="{{ layout }}"
            {% if layout == layout_name %}selected="selected"{% endif %}
          >
            {{ template_settings.humanized_layout_names[layout] }}
          </option>
        {% endfor %}
      </select>
    </div>
  {%- endif -%}
{%- endcapture -%}

{%- unless editmode -%}
  {%- assign block_has_content = false -%}

  {%- for index in (1..content_area_count) -%}
    {%- assign block_area_name = "block-" | append: id | append: "-col-" | append: index -%}

    {%- capture block_contents_html -%}
      {% content name=block_area_name %}
    {%- endcapture -%}

    {%- if block_contents_html != blank -%}
      {%- assign block_has_content = true -%}
      {%- break -%}
    {%- endif -%}

  {%- endfor -%}
{%- endunless -%}

{%- if editmode or block_has_content %}
  <div
    class="block-wrapper{% if wrapper_class %} {{ wrapper_class }}{% endif %}"
    data-block-key="{{ id }}"
  >
    {%- if editmode %}
      <div class="block-edit-buttons">
        {{ move_buttons }}
        {{ delete_button }}
        {{ change_layout_options }}
      </div>
    {%- endif %}

    {%- if layout_data.separate_bg_pickers == true -%}
      {% for index in (1..content_area_count) %}
        {%- assign background_key =
          "block_"
          | append: id
          | append: "_col_"
          | append: index
          | append: "_background"
        -%}
        {%- assign background = block_data[background_key] -%}

        {%- include "block-structure",
          animated: animated,
          background: background,
          background_key: background_key,
          block_index: index,
          content_area_count: 1,
          content_class: content_class,
          id: id,
          layout_name: layout_name,
          separate_bg_pickers: layout_data.separate_bg_pickers
        -%}
      {% endfor %}
    {%- else -%}
      {%- assign background_key =
        "block_"
        | append: id
        | append: "_col_1_background"
      -%}

      {%- assign background = block_data[background_key] -%}

      {% include "block-structure",
        animated: animated,
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
{%- endif %}
