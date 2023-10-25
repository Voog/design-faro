<script type="text/javascript">
  var siteData = new Edicy.CustomData({
    type: 'site'
  });

  var pageData = new Edicy.CustomData({
    type: 'page',
    id: '{{ page.id }}'
  });

  var pageBlockData = '{{ body_blocks | json }}';
  var parsedBlockData = JSON.parse(pageBlockData || '{}');

  $(function() {
    $('.bg-picker-area').each(function(index, pickerArea) {
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
          var commitData = site.bgPickerCommit({
            bgPicker,
            blockData: parsedBlockData,
            blockKey: pickerOpts.block_key,
            data,
            dataBgKey: pickerOpts.bg_key,
            dataKey: pickerOpts.data_key,
            pageType: pickerOpts.entity
          });

          if (commitData) {
            parsedBlockData = commitData;
          }
        }
      });
    });
  })
</script>
