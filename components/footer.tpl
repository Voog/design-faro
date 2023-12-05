<footer class="footer">
  <div class="footer-content">
    {%- assign footer_content_title = "cross_site_footer" | lce -%}
    {%- assign footer_content_title_tooltip = "content_tooltip_all_pages_same_language" | lce -%}
    <div class="content-formatted">
      {% xcontent
        name="footer-col-1"
        title=footer_content_title
        title_tooltip=footer_content_title_tooltip
      %}
    </div>
    <div class="content-formatted">
      {% xcontent
        name="footer-col-2"
        title=footer_content_title
        title_tooltip=footer_content_title_tooltip
      %}
    </div>
    <div class="content-formatted">
      {% xcontent
        name="footer-col-3"
        title=footer_content_title
        title_tooltip=footer_content_title_tooltip
      %}
    </div>
    <div class="content-formatted">
      {% xcontent
        name="footer-col-4"
        title=footer_content_title
        title_tooltip=footer_content_title_tooltip
      %}
    </div>
  </div>
</footer>
