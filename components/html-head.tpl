{%- comment -%}IE SETTINGS{%- endcomment -%}
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->

{%- comment -%}BASIC META INFO{%- endcomment -%}
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<meta name="format-detection" content="telephone=no">

{%- comment -%}FAV ICON{%- endcomment -%}
{% if site.has_favicon? %}
  <link rel="icon" href="/favicon.ico" type="image/x-icon">
  <link rel="shortcut icon" href="/favicon.ico" type="image/ico">
  <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
{% endif %}

{%- comment -%}STYLESHEETS{%- endcomment -%}
<link
  href="{{ stylesheets_path }}/main.min.css?v={{ template_settings.version }}"
  media="screen"
  rel="stylesheet"
  type="text/css"
/>

{% if editmode -%}
  {% stylesheet_link "libs/edicy-tools/latest/edicy-tools.css" static_host="true" %}
{%- endif %}

{% if site.search.enabled -%}
  {% stylesheet_link "libs/edicy-search/latest/edicy-search.css" static_host="true" %}
{%- endif %}

{%- customstyle -%}
  {%- include "template-cs-main-styles" -%}
  {%- include "template-cs-headings" -%}
  {%- include "template-cs-content" -%}
  {%- if product_page -%}
    {%- include "template-cs-product" -%}
  {%- endif -%}
  {%- include "template-cs-button" -%}
  {%- include "template-cs-header" -%}
  {%- include "template-cs-footer" -%}
{%- endcustomstyle -%}

{%- comment -%}SITE TITLE{%- endcomment -%}
<title>{% title %}</title>

{%- comment -%}MISC{%- endcomment -%}
{% include "template-meta" %}

{%- comment -%}BREADCRUMBS{%- endcomment -%}
{%- capture breadcrumbs_script -%}
  {%- sd_breadcrumbs -%}
{%- endcapture -%}

{% sd_breadcrumbs %}

{% if blog %}{{ blog.rss_link }}{% endif %}
{{ site.stats_header }}
