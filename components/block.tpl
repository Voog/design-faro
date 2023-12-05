{%- assign id = block_data.key -%}
{%- assign content_area_count = layout_data.content_areas | default: 1 -%}

{%- capture move_buttons -%}
  <button
    class="move-button up-button js-move-button"
    title="Move block up"
    data-key="{{ id }}"
    data-direction="up"
    data-wrapper-class="{{ wrapper_class }}"
  ></button>
  <button
    class="move-button down-button js-move-button"
    title="Move block down"
    data-key="{{ id }}"
    data-direction="down"
    data-wrapper-class="{{ wrapper_class }}"
  ></button>
{%- endcapture -%}

{%- capture delete_button -%}
  <button
    class="delete-button js-delete-button"
    title="Delete block"
    data-key="{{ id }}"
    data-wrapper-class="{{ wrapper_class }}"
  ></button>
{%- endcapture -%}

{%- capture change_layout_options -%}
  {%- if allowed_layouts.size > 1 -%}
    <div class="change-layout-options">
      <select class="js-change-layout-select" title="Change block layout">
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

{%- if editmode -%}
  {%- assign block_has_content = true -%}
{%- else -%}
  {%- capture block_contents_html -%}
    {%- for index in (1..content_area_count) -%}
      {%- assign block_area_name = "block-" | append: id | append: "-col-" | append: index -%}

      {% content name=block_area_name %}
    {%- endfor -%}
  {%- endcapture -%}

  {%- capture block_contents_size -%}
    {{- block_contents_html | size | minus: 1 -}}
  {%- endcapture -%}

  {%- if block_contents_size contains "-" -%}
    {%- assign block_has_content = false -%}
  {%- else -%}
    {%- assign block_has_content = true -%}
  {%- endif -%}
{%- endif -%}

{%- if block_has_content %}
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
