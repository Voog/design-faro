<div class="header-wrapper">
  <div class="header">
    {% include "menu-main" %}

    <div class="header-content">
      {% xcontent name="header" %}
    </div>

    <div class="header-right">
      {{ "search" | lce | escape_once }}
      {% include "menu-lang" %}
    </div>
  </div>
</div>
