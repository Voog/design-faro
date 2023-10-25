<!DOCTYPE html>
{% include "template-settings" %}
{% include "template-variables" %}
<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" -%}
    {%- include "template-styles" -%}
  </head>

  <body class="categories-page full-height-body">
    {% include "header" %}

    <main class="categories-page-content" role="main" data-search-indexing-allowed="true">
      {% for block_data in body_blocks %}
        {% if template_settings.common_page_block_layouts[block_data.layout] == blank %}
          {% assign layout_name = template_settings.default_block_layouts.categories_page %}
        {% else %}
          {% assign layout_name = block_data.layout %}
        {% endif %}

        {% assign layout_data = template_settings.categories_page_block_layouts[layout_name] %}

        {% include "block",
          block_data: block_data,
          layout_name: layout_name,
          layout_data: layout_data,
          content_class_name: "js-category-section",
          wrapper_class: "js-categories-wrapper"
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

    <script>
      if (site) {
        site.handleCategoriesPageContent();
        {% if editmode -%}

          site.handleBlockReorder({
            bodyBlocks: blockData,
            dataKey: "{{ body_blocks_key }}"
          });
        {%- endif -%}
      }
    </script>
  </body>
</html>
