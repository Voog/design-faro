{% capture dont_render %}
  {%- assign body_bg_key = template_settings.page.body_bg.key -%}
  {%- assign body_blocks_key = template_settings.page.body_blocks.key -%}
  {%- assign front_page_settings_key = template_settings.page.front_page_settings.key -%}
  {%- assign product_body_bg_key = template_settings.product.body_bg.key -%}

  {%- if product_page -%}
    {%- assign body_bg = site.data[product_body_bg_key] -%}
  {%- else -%}
    {%- assign body_bg = page.data[body_bg_key] -%}
  {%- endif -%}

  {%- assign body_blocks =
    page.data[body_blocks_key]
    | default: template_settings.page.body_blocks.value
  -%}

  {%- assign front_page_settings = page.data[front_page_settings_key] -%}

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

  {% assign front_page_layout =
    front_page_settings.layout
    | default: template_settings.page.front_page_settings.value.layout
  %}

  {% comment %}
    Design editor variables.
  {% endcomment %}

  {% capture base_font_set %}
    [
      {
        "type": "group",
        "title": "Sans Serif",
        "list": [
          {
            "title": "Fira Sans",
            "value": "\"Fira Sans\", sans-serif"
          },
          {
            "title": "Lato",
            "value": "\"Lato\", sans-serif"
          },
          {
            "title": "Montserrat",
            "value": "\"Montserrat\", sans-serif"
          },
          {
            "title": "Open Sans",
            "value": "\"Open Sans\", sans-serif"
          },
          {
            "title": "PT Sans",
            "value": "\"PT Sans\", sans-serif"
          },
          {
            "title": "Raleway",
            "value": "\"Raleway\", sans-serif"
          },
          {
            "title": "Roboto",
            "value": "\"Roboto\", sans-serif"
          },
          {
            "title": "Source Sans Pro",
            "value": "\"Source Sans Pro\", sans-serif"
          },
          {
            "title": "Ubuntu",
            "value": "\"Ubuntu\", sans-serif"
          }
        ]
      },
      {
        "type": "group",
        "title": "Serif",
        "list": [
          {
            "title": "Arvo",
            "value": "\"Arvo\", serif"
          },
          {
            "title": "Crimson Text",
            "value": "\"Crimson Text\", serif"
          },
          {
            "title": "Georgia",
            "value": "\"Georgia\", serif"
          },
          {
            "title": "Lora",
            "value": "\"Lora\", serif"
          },
          {
            "title": "Noto Serif",
            "value": "\"Noto Serif\", serif"
          },
          {
            "title": "Playfair Display",
            "value": "\"Playfair Display\", serif"
          },
          {
            "title": "PT Serif",
            "value": "\"PT Serif\", serif"
          },
          {
            "title": "Roboto Slab",
            "value": "\"Roboto Slab\", serif"
          }
        ]
      },
      {
        "type": "group",
        "title": "Monospace",
        "list": [
          {
            "title": "Anonymous Pro",
            "value": "\"Anonymous Pro\", monospace"
          },
          {
            "title": "Cousine",
            "value": "\"Cousine\", monospace"
          },
          {
            "title": "Roboto Mono",
            "value": "\"Roboto Mono\", monospace"
          },
          {
            "title": "Ubuntu Mono",
            "value": "\"Ubuntu Mono\", monospace"
          }
        ]
      }
    ]
  {% endcapture %}

{% endcapture %}
