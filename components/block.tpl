{% assign left_content_name = "block-content-left-" | append: block_id %}
{% assign right_content_name = "block-content-right-" | append: block_id %}

{%- capture block_content_html -%}
  {%- unless editmode -%}
    {%- content name=left_content_name -%}
    {%- content name=right_content_name -%}
  {%- endunless -%}
{%- endcapture -%}

{%- capture block_content_size -%}
  {{- block_content_html | size | minus: 1 -}}
{%- endcapture -%}

{%- unless block_content_size contains "-" -%}
  {%- assign block_has_content = true -%}
{%- endunless -%}

{% if editmode or block_has_content -%}
  <div class="block block-{{ block_type }}">
    <div class="wrapper">
      <div class="content-formatted">
        {% content name=left_content_name %}
      </div>
      <div class="content-formatted">
        {% content name=right_content_name %}
      </div>
    </div>
  </div>
{% endif -%}
