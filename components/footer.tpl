{%- unless editmode -%}
  {%- assign footer_has_content = false -%}

  {%- for index in (1..4) -%}
    {%- assign footer_content_name = "footer-col-" | append: index -%}

    {%- capture footer_content_html -%}
      {% xcontent name=footer_content_name %}
    {%- endcapture -%}

    {%- if footer_content_html != blank -%}
      {%- assign footer_has_content = true -%}
      {%- break -%}
    {%- endif -%}
  {%- endfor -%}
{%- endunless -%}

{%- if editmode or footer_has_content %}
  <footer class="footer">
    <div class="footer-content">
      {%- assign footer_content_title = "cross_site_footer" | lce -%}
      {%- assign footer_content_title_tooltip = "content_tooltip_all_pages_same_language" | lce -%}

      {%- for index in (1..4) -%}
        {%- assign footer_content_name = "footer-col-" | append: index -%}

        <div class="content-formatted">
          {% xcontent
            name=footer_content_name
            title=footer_content_title
            title_tooltip=footer_content_title_tooltip
          %}
        </div>
      {%- endfor -%}
    </div>
  </footer>
{%- endif -%}
