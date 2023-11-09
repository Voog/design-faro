<!DOCTYPE html>
{% include "template-settings" %}
{% include "template-variables" %}
<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" -%}
    {%- include "template-styles" -%}
  </head>

  <body class="categories-page">
    {% include "header" %}

    <main class="categories-page-content" role="main" data-search-indexing-allowed="true">
      {%- include "ico-chevron" classname: "ico-hidden" -%}
      {%- include "ico-trash" classname: "ico-hidden" -%}
      {% assign allowed_layouts = template_settings.categories_page_block_layouts | map: "key" %}

      <div class="category-blocks">
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
              content_class: "js-category-section",
              wrapper_class: "js-categories-wrapper"
            %}
        {% endfor %}
      </div>

      {% if editmode %}
        <div class="add-block-wrapper">
          <button
            class="add-block-button js-add-block"
            data-block-layout="{{ template_settings.default_block_layouts.categories_page }}"
          >
            +
          </button>
        </div>
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
        {% if editmode -%}
          site.bindBlockActions({
            bodyBlocks: blockData,
            dataKey: "{{ body_blocks_key }}"
          });
        {%- endif -%}
      }
    </script>
  </body>
</html>
