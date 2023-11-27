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
              wrapper_class: "js-categories-wrapper"
            %}
        {% endfor %}
      </div>
    </main>

    {% if editmode %}
      <div class="add-block-wrapper">
        <button
          class="add-block-button js-add-block"
          data-block-layout="{{ template_settings.default_block_layouts.categories_page }}"
        >
          {%- include "ico-cross" -%}
        </button>
      </div>
    {% endif %}

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
            deleteConfirmation: 'Are you sure?'{% comment %}TODO: use localized translation{% endcomment %}
          });
        }
      </script>
    {%- endif -%}
  </body>
</html>
