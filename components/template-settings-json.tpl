{
  "page": {
    "body_bg": {
      "key": "PREFIX_body_bg",
      "value": {}
    },
    "front_page_settings": {
      "key": "PREFIX_front_page_settings",
      "value": {
        "layout": "split_dominant_right"
      }
    },
    "body_blocks": {
      "key": "PREFIX_body_blocks",
      "value": [
        {
          "key": "1",
          "block_1_col_1_background": {}
        }
      ]
    }
  },
  "product": {
    "body_bg": {
      "key": "PREFIX_product_body_bg",
      "value": {}
    }
  },
  "common_page_block_layouts": [
    {
      "key": "split_40_60",
      "value": {
        "content_areas": "2"
      }
    },
    {
      "key": "split_60_40",
      "value": {
        "content_areas": "2"
      }
    },
    {
      "key": "column",
      "value": {
        "content_areas": "1"
      }
    },
    {
      "key": "split_staggered",
      "value": {
        "content_areas": "2"
      }
    }
  ],
  "categories_page_block_layouts": [
    {
      "key": "split_50_50_full",
      "value": {
        "content_areas": "2",
        "separate_bg_pickers": true
      }
    }
  ],
  "default_block_layouts": {
    "common_page": "split_40_60",
    "categories_page": "split_50_50_full"
  },
  "front_page_layouts": [
    "split_dominant_right",
    "column",
    "split_even"
  ],
  "humanized_layout_names": {
    "split_even": {{ "split" | lce | json }},
    "column": {{ "column" | lce | json }},
    "split_dominant_right": {{ "dominant_right" | lce | json }},
    "split_40_60": {{ "dominant_right" | lce | json }},
    "split_60_40": {{ "dominant_left" | lce | json }},
    "split_staggered": {{ "staggered" | lce | json }},
    "split_50_50_full": {{ "full_height" | lce | json }}
  },
  "version": "faro-1.0.4"
}
