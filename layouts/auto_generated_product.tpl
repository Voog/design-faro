<!DOCTYPE html>
{% include "template-settings" %}
{% include "template-variables" product_page: true %}

{%- capture product_social_html -%}
  {%- assign cross_page_info_title = "cross_page_info" | lce  -%}
  {%- assign cross_page_info_title_tooltip = "content_tooltip_all_pages_same_type" | lce -%}
  {% xcontent
    name="product-social"
    title=cross_page_info_title
    title_tooltip=cross_page_info_title_tooltip
  %}
{%- endcapture -%}

{%- capture footnote_content_html -%}
  {%- content bind=product name="footnote" -%}
{%- endcapture -%}

{%- capture bottom_content_html -%}
  {%- assign bottom_content_title = "additional_content" | lce -%}
  {%- assign bottom_content_title_tooltip = "content_tooltip_additional_information" | lce -%}
  {% content
    bind=product
    name="content"
    title=bottom_content_title
    title_tooltip=bottom_content_title_tooltip
  %}
{%- endcapture -%}

<html class="{% if editmode %}editmode{% else %}publicmode{% endif %}" lang="{{ page.language_code }}">
  <head prefix="og: http://ogp.me/ns#">
    {%- include "html-head" product_page: true -%}
    {%- include "template-styles" -%}
    {%- sd_product -%}
  </head>

  <body class="product-page bg-picker-area body-bg-picker-area js-background-type {{ body_bg_type }}">
    {% include "header" %}
    <div class="body-bg-color js-background-color"></div>

    {%- if editmode -%}
      <button
        class="voog-bg-picker-btn bg-picker {{ product_body_bg_key }}-picker"
        data-bg_key="{{ product_body_bg_key }}"
        data-type_picture="false"
        data-type_color="true"
        data-color_elem=".body-bg-color"
        data-picker_area_elem=".body-bg-picker-area"
        data-picker_elem =".{{ product_body_bg_key }}-picker"
        data-bg-color="{{ body_bg_color }}"
        data-entity="productPage"
      ></button>
    {%- endif -%}

    <main class="product-page-content" role="main" data-search-indexing-allowed="true">
      <div class="split-section">
        <div class="product-image-section">
          {%- if product.photos != blank %}
            {% assign item_image_state = "with-images" %}
          {% else %}
            {% assign item_image_state = "without-images" %}
          {% endif -%}

          <div class="product-image {{ item_image_state }}">
            {%- if product.photos != blank -%}
              {% gallery product layout="product_slider" %}
            {%- endif -%}
          </div>
        </div>
        <div class="product-information">
          <div class="content-formatted information-section">
            <h4 class="product-name">
              {% editable product.name %}
            </h4>

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

            {%- if product_social_html != blank -%}
              <div class="product-social">
                {{ product_social_html }}
              </div>
            {%- endif -%}

            {%- assign content_title = "content" | lce -%}
            {%- assign content_title_tooltip = "content_tooltip_specific_page" | lce -%}
            {% content bind=product title=content_title title_tooltip=content_title_tooltip  %}
          </div>

          {% if footnote_content_html != blank %}
            <div class="product-footnote">
              {{ footnote_content_html }}
            </div>
          {% endif %}
        </div>
      </div>

      {%- if bottom_content_html != blank -%}
        <div class="content-formatted product-additional-content">
          {{ bottom_content_html }}
        </div>
      {%- endif -%}
    </main>

    {% include "footer" %}

    {% if editmode -%}
      <script>
        let blockData = {};
      </script>
    {% endif -%}

    {% include "javascripts" %}
  </body>
</html>
