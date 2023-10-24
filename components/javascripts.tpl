{% comment %}SITE WIDE JAVASCRIPTS{% endcomment %}
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4=" crossorigin="anonymous"></script>
<script src="{{ javascripts_path }}/application.min.js?v={{ template_settings.version }}"></script>
{% if editmode -%}
  <script src="{{ javascripts_path }}/editmode.min.js?v={{ template_settings.version }}"></script>
{%- endif %}

{% sitejs_include %}

{% comment %}Site search related javascript components.{% endcomment %}
{% if site.search.enabled -%}
  <script src="{{ site.static_asset_host }}/libs/edicy-search/latest/edicy-search.js"></script>
  <script>site.bindSiteSearch($('.js-search-form').get(0), '{{ page.language_code }}', {{ "search_noresults" | lc | json }});</script>
{%- endif %}

{% comment %}SITE ANALYTICS INITIATION{% endcomment %}
{% unless editmode %}{{ site.analytics }}{% endunless %}

{% if editmode %}
  {% editorjsblock %}
    <script src="{{ site.static_asset_host }}/libs/edicy-tools/latest/edicy-tools.js"></script>
    {%- include "bg-picker-scripts" -%}
  {% endeditorjsblock %}
{% endif %}
