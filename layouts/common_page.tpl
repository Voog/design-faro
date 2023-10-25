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
      {% for block_data in body_blocks %}
        {% if template_settings.common_page_block_layouts[block_data.layout] == blank %}
          {% assign layout_name = template_settings.default_block_layouts.common_page %}
        {% else %}
          {% assign layout_name = block_data.layout %}
        {% endif %}

        {% assign layout_data = template_settings.common_page_block_layouts[layout_name] %}

        {% include "block",
          block_data: block_data,
          layout_name: layout_name,
          layout_data: layout_data,
          wrapper_class: "js-blocks-wrapper"
        %}
      {% endfor %}
    </main>

    {% include "footer" %}

    {% if editmode -%}
      <script>
        let blockData = {{ body_blocks | json }};
      </script>
    {% endif -%}

    {% include "javascripts" %}

    {% if editmode -%}
      <script>
        if (site) {
          site.handleBlockReorder({
            bodyBlocks: blockData,
            dataKey: "{{ body_blocks_key }}"
          });
        }
      </script>
    {%- endif -%}
  </body>
</html>
