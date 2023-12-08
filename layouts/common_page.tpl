<!DOCTYPE html>
{% include "template-settings" %}
{% include "template-variables" %}
<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" -%}
    {%- include "template-styles" -%}
  </head>

  <body class="common-page">
    {% include "header" %}

    <main class="common-page-content" role="main" data-search-indexing-allowed="true">
      {%- assign allowed_layouts = template_settings.common_page_block_layouts | map: "key" -%}

      {%- for block_data in body_blocks %}
        {%- assign layout =
          block_data.layout
          | default: template_settings.default_block_layouts.common_page
        -%}

        {%- assign allowed_layout =
          template_settings.common_page_block_layouts
          | where: "key", layout
        -%}

        {%- if allowed_layout.size == 0 -%}
          {%- assign layout_name = template_settings.default_block_layouts.common_page -%}
        {%- else -%}
          {%- assign layout_name = layout -%}
        {%- endif -%}

        {%- assign layout_data = allowed_layout.first.value -%}

        {% include "block",
          allowed_layouts: allowed_layouts,
          block_data: block_data,
          layout_name: layout_name,
          layout_data: layout_data,
          wrapper_class: "js-blocks-wrapper"
        -%}
      {%- endfor %}
    </main>

    {%- if editmode %}
      <div class="add-block-wrapper">
        <button
          class="add-block-button js-add-block"
          data-title="{{ 'add_new_block' | lce }}"
          data-block-layout="{{ template_settings.default_block_layouts.common_page }}"
        >
          {%- include "ico-cross" -%}
        </button>
      </div>
    {%- endif %}

    {% include "footer" %}

    {% if editmode -%}
      <script>
        let rawBlockData = '{{ body_blocks | json }}';
        let blockData = JSON.parse(rawBlockData || '{}');
      </script>
    {% endif -%}

    {% include "javascripts" %}

    {% if editmode -%}
      <script>
        if (site) {
          site.bindBlockActions({
            bodyBlocks: blockData,
            dataKey: "{{ body_blocks_key }}",
            deleteConfirmation: '{{ "are_you_sure" | lce }}',
          });
        }
      </script>
    {%- endif -%}
  </body>
</html>
