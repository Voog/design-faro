<style>
  {% comment %}/* Body background color style */{% endcomment %}
  :root {
    --body-bg-color: {{ body_bg_color }};
    --body-bg-color-rgb: {{ body_bg_color_data.r | default: 255 }}, {{ body_bg_color_data.g | default: 255 }}, {{ body_bg_color_data.b | default: 255 }};
  }
</style>
