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
      {% assign allowed_layouts = template_settings.categories_page_block_layouts | map: "key" %}

      {% for block_data in body_blocks %}
        {% assign layout =
          block_data.layout
          | default: template_settings.default_block_layouts.categories_page
        %}

        {% assign allowed_layout =
          template_settings.categories_page_block_layouts
          | where: "key", layout
        %}

        {% if allowed_layout.size == 0 %}
          {% assign layout_name = template_settings.default_block_layouts.categories_page %}
        {% else %}
          {% assign layout_name = layout %}
        {% endif %}

        {% assign layout_data = allowed_layout.first.value %}

        {% include "block",
          block_data: block_data,
          layout_name: layout_name,
          layout_data: layout_data,
          content_class_name: "js-category-section",
          wrapper_class: "js-categories-wrapper"
        %}
      {% endfor %}

      {% if editmode %}
        {% for layout in allowed_layouts %}
          <button class="add-block js-add-block" data-block-layout="{{ layout }}">
            {{ layout }}
          </button>
        {% endfor %}
      {% endif %}
    </main>

    {% include "footer" %}

    {% if editmode -%}
      <script>
        let rawBlockData = '{{ body_blocks | json }}';
        let blockData = JSON.parse(rawBlockData || '{}');
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

          site.handleBlockAdd({
            bodyBlocks: blockData,
            dataKey: "{{ body_blocks_key }}",
          });
        {%- endif -%}
      }
    </script>
  </body>
</html>
