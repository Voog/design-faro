:root {
  /* VoogStyle
    "pathI18n": ["footer", "text"],
    "titleI18n": "line_height",
    "editor": "rangePicker",
    "min": 0,
    "max": 5,
    "step": 0.1,
    "unit": "",
    "scope": "global"
  */
  --footer-body-line-height: 1.7;
  /* VoogStyle
    "pathI18n": ["footer", "text"],
    "titleI18n": "size",
    "editor": "rangePicker",
    "min": 8,
    "max": 56,
    "unit": "px",
    "scope": "global"
  */
  --footer-body-font-size: 16px;
  /* VoogStyle
    "pathI18n": ["footer", "text"],
    "titleI18n": "color",
    "editor": "colorPicker",
    "featured": true,
    "scope": "global"
  */
  --footer-body-color: #000000;
  /* VoogStyle
    "pathI18n": ["footer", "text"],
    "titleI18n": "hyphens",
    "editor": "listPicker",
    "list": {{ base_hyphens_toggle_set }},
    "scope": "global"
  */
  --footer-body-hyphens: none;
  /* VoogStyle
    "pathI18n": ["footer", "link", "normal"],
    "titleI18n": "color",
    "type": "button",
    "editor": "colorPicker",
    "featured": true,
    "scope": "global"
  */
  --footer-link-color: #000000;
  /* VoogStyle
    "pathI18n": ["footer", "link", "normal"],
    "titleI18n": "font_size",
    "type": "button",
    "editor": "toggleIcon",
    "states": {
      "on": "700",
      "off": "400"
    },
    "icon": "bold",
    "scope": "global",
    "boundVariables": [
      "--footer-link-hover-font-weight"
    ]
  */
  --footer-link-font-weight: 400;
  /* VoogStyle
    "pathI18n": ["footer", "link", "normal"],
    "titleI18n": "font_style",
    "type": "button",
    "editor": "toggleIcon",
    "states": {
      "on": "italic",
      "off": "normal"
    },
    "icon": "italic",
    "scope": "global",
    "boundVariables": [
      "--footer-link-hover-font-style"
    ]
  */
  --footer-link-font-style: normal;
  /* VoogStyle
    "pathI18n": ["footer", "link", "normal"],
    "titleI18n": "text_decoration",
    "type": "button",
    "editor": "toggleIcon",
    "states": {
      "on": "underline",
      "off": "none"
    },
    "icon": "underline",
    "scope": "global",
    "boundVariables": [
      "--footer-link-hover-text-decoration"
    ]
  */
  --footer-link-text-decoration: underline;
  /* VoogStyle
    "pathI18n": ["footer", "link", "normal"],
    "titleI18n": "text_transform",
    "type": "button",
    "editor": "toggleIcon",
    "states": {
      "on": "uppercase",
      "off": "none"
    },
    "icon": "uppercase",
    "scope": "global",
    "boundVariables": [
      "--footer-link-hover-text-transform"
    ]
  */
  --footer-link-text-transform: none;
  /* VoogStyle
    "pathI18n": ["footer", "link", "hover"],
    "titleI18n": "color",
    "type": "button",
    "editor": "colorPicker",
    "featured": true,
    "scope": "global"
  */
  --footer-link-hover-color: rgba(0, 0, 0, 0.7);
  /* VoogStyle
    "pathI18n": ["footer", "link", "hover"],
    "titleI18n": "font_size",
    "type": "button",
    "editor": "toggleIcon",
    "states": {
      "on": "700",
      "off": "400"
    },
    "icon": "bold",
    "scope": "global"
  */
  --footer-link-hover-font-weight: 400;
  /* VoogStyle
    "pathI18n": ["footer", "link", "hover"],
    "titleI18n": "font_style",
    "type": "button",
    "editor": "toggleIcon",
    "states": {
      "on": "italic",
      "off": "normal"
    },
    "icon": "italic",
    "scope": "global"
  */
  --footer-link-hover-font-style: normal;
  /* VoogStyle
    "pathI18n": ["footer", "link", "hover"],
    "titleI18n": "text_decoration",
    "type": "button",
    "editor": "toggleIcon",
    "states": {
      "on": "underline",
      "off": "none"
    },
    "icon": "underline",
    "scope": "global"
  */
  --footer-link-hover-text-decoration: none;
  /* VoogStyle
    "pathI18n": ["footer", "link", "hover"],
    "titleI18n": "text_transform",
    "type": "button",
    "editor": "toggleIcon",
    "states": {
      "on": "uppercase",
      "off": "none"
    },
    "icon": "uppercase",
    "scope": "global"
  */
  --footer-link-hover-text-transform: none;
}
