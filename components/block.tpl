<div class="block block-{{ block_type }}">
  <div class="wrapper">
    <div class="content-formatted">
      {% assign left_content_name = "block-content-left-" | append: block_id %}
      {% content name=left_content_name %}
    </div>
    <div class="content-formatted">
      {% assign right_content_name = "block-content-right-" | append: block_id %}
      {% content name=right_content_name %}
    </div>
  </div>
</div>
