{%- assign breadcrumbs_string = breadcrumbs_script
  | replace: '<script type="application/ld+json">', ''
  | replace: "</script>", ''
  | replace: site.url, ''
  | replace: '@', ''
-%}
{%- assign breadcrumbs_obj = breadcrumbs_string | json_parse -%}

<nav class="menu-sub menu-breadcrumbs">
  {% for list_item in breadcrumbs_obj.itemListElement %}
    {%- assign page_url = page.url | remove_first: "/" -%}
    <span class="menu-item
      {%- unless forloop.last %} divider{% endunless -%}
      {%- if page_url == list_item.item.id %} active{% endif -%}
    ">
      <a href="/{{ list_item.item.id }}">{{ list_item.item.name }}</a>
    </span>
  {% endfor %}
</nav>
