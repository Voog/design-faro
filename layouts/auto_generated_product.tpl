<!DOCTYPE html>
{% include "template-settings" %}
{% include "template-variables" %}

{% capture bottom_content_html %}
  {%- unless editmode -%}
    {%- content bind=product name="content" -%}
  {%- endunless -%}
{% endcapture %}

{% capture bottom_content_size %}
  {{- bottom_content_html | size | minus: 1 -}}
{% endcapture %}

{% unless bottom_content_size contains "-" %}
  {% assign bottom_content_has_content = true %}
{% endunless %}

{%- capture product_social_html -%}
  {%- unless editmode -%}
    {%- xcontent name="product-social" -%}
  {%- endunless -%}
{%- endcapture -%}

{%- assign product_social_size = product_social_html | strip | size -%}

<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" -%}
    {%- include "template-styles" -%}
  </head>

  <body class="product-page">
    {% include "header" %}

    <main class="product-page-content" role="main" data-search-indexing-allowed="true">
      <div class="split-section">
        <div class="product-image-section">
          {%- if product.image != blank %}
            {% assign item_image_state = "with-image" %}
          {% else %}
            {% assign item_image_state = "without-image" %}
          {% endif -%}

          <div class="product-image {{ item_image_state }}">
            {%- if product.image != blank -%}
              {% image product.image loading: 'lazy' target_width: "600" class: "item-image" %}
            {%- endif -%}
          </div>
        </div>
        <div class="product-information">
          <div class="content-formatted">
            <h3 class="product-name">
              {% editable product.name %}
            </h3>

            {%- capture original_price -%}
              {% if product.price_min_with_tax != product.price_max_with_tax -%}
                {{- product.price_min_with_tax | money_with_currency: product.currency -}}
                <span> – </span>
              {%- endif -%}
              {{- product.price_max_with_tax | money_with_currency: product.currency -}}
            {%- endcapture -%}

            <div class="product-price">
              {% if product.on_sale? -%}
                <s class="product-price-original">
                  {{- original_price -}}
                </s>
              {% endif -%}

              <span class="product-price-final">
                {%- if product.on_sale? -%}
                  {% if product.effective_price_min_with_tax != product.effective_price_max_with_tax %}
                    {{- product.effective_price_min_with_tax | money_with_currency: product.currency -}}
                    <span> – </span>
                  {%- endif -%}
                  {{- product.effective_price_max_with_tax | money_with_currency: product.currency -}}
                {% else %}
                  {{ original_price }}
                {% endif -%}
              </span>
            </div>

            {%- if editmode or product.description != blank -%}
              <div class="product-description content-formatted">
                {%- editable product.description -%}
              </div>
            {%- endif -%}

            <div class="product-buy-button">
              {% include "buy-button" %}
            </div>

            {%- if editmode or product_social_size > 0 -%}
              <div class="product-social">
                {%- assign cross_page_info_title = "cross_page_info" | lce  -%}
                {%- assign cross_page_info_title_tooltip = "content_tooltip_all_pages_same_type" | lce -%}
                {% xcontent
                  name="product-social"
                  title=cross_page_info_title
                  title_tooltip=cross_page_info_title_tooltip
                %}
              </div>
            {%- endif -%}

            {%- assign content_title = "content" | lce -%}
            {%- assign content_title_tooltip = "content_tooltip_specific_page" | lce -%}
            {% content bind=product title=content_title title_tooltip=content_title_tooltip  %}
          </div>
        </div>
      </div>

      {%- if bottom_content_has_content == true or editmode -%}
        <div class="content-formatted product-additional-content">
          {%- assign bottom_content_title = "additional_content" | lce -%}
          {%- assign bottom_content_title_tooltip = "content_tooltip_additional_information" | lce -%}
          {% content
            bind=product
            name="content"
            title=bottom_content_title
            title_tooltip=bottom_content_title_tooltip
          %}
        </section>
      {%- endif -%}
    </main>

    {%- include "javascripts" -%}
  </body>
</html>
