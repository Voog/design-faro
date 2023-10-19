<!DOCTYPE html>
{% include "template-settings" %}
{% include "template-variables" %}
<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" -%}
    {%- include "template-styles" -%}
  </head>

  <body class="categories-page full-height-body">
    {% include "header", fixed: true %}

    <main class="categories-page-content">
      {% for section in categories_page_sections %}
        {%- assign section_id = section[0] -%}
        {%- assign section_data = section[1] -%}

        {%- assign left_content_name = "categories-left-" | append: section_id -%}
        {%- assign right_content_name = "categories-right-" | append: section_id -%}

        <div class="content-formatted">
          {% content name=left_content_name %}
        </div>
        <div class="content-formatted">
          {% content name=right_content_name %}
        </div>
      {% endfor %}
    </main>
    {%- include "javascripts" -%}
  </body>
</html>
