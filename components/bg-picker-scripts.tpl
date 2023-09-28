<script type="text/javascript">
  var siteData = new Edicy.CustomData({
    type: 'site'
  });

  var pageData = new Edicy.CustomData({
    type: 'page',
    id: '{{ page.id }}'
  });

  $(function() {
    $('.body-bg-picker-area').each(function(index, pickerArea) {
      var $picker = $(pickerArea).find('.bg-picker');
      var pickerOpts = $picker.data();

      var bgPicker = new Edicy.BgPicker($picker, {
        picture: pickerOpts.type_picture,
        color: pickerOpts.type_color,
        showAlpha: true,
        target_width: pickerOpts.width,
        preview: function(data) {
          site.bgPickerPreview(
            pickerArea,
            {
              ...data,
              variableName: pickerOpts.variable_name || 'body-bg-color'
            },
            bgPicker
          );
        },
        commit: function(data) {
          site.bgPickerCommit(pickerOpts.bg_key, data, bgPicker, pickerOpts.entity);
        }
      });
    });
  })
</script>
