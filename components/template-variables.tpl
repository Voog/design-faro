{% capture dont_render %}
  {%- assign body_bg_key = template_settings.page.body_bg.key -%}

  {%- assign body_bg = page.data[body_bg_key] -%}
  {% comment %}Assign variables based on page type.{% endcomment %}
  {% assign body_bg_color = body_bg.color %}
  {%- if body_bg_color == blank -%}
    {%- assign body_bg_color = 'none' -%}
  {%- endif -%}

  {% assign body_bg_color_data = body_bg.colorData %}
  {% assign body_bg_combined_lightness = body_bg.combinedLightness %}

  {% if body_bg %}
    {% if body_bg_combined_lightness %}
      {% if body_bg_combined_lightness > 0.6 %}
        {% assign body_bg_type = "light-background" %}
      {% else %}
        {% assign body_bg_type = "dark-background" %}
      {% endif %}
    {% else %}
      {% if body_bg_color_data.a >= 0.6 %}
        {% if body_bg_color_data.lightness >= 0.6 %}
          {% assign body_bg_type = "light-background" %}
        {% else %}
          {% assign body_bg_type = "dark-background" %}
        {% endif %}
      {% else %}
        {% assign body_bg_type = "light-background" %}
      {% endif %}
    {% endif %}
  {% else %}
    {% assign body_bg_type = "light-background" %}
  {% endif %}

{% endcapture %}
