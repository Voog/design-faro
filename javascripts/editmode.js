(function (factory) {
  typeof define === 'function' && define.amd ? define(factory) :
  factory();
})((function () { 'use strict';

  (function ($) {
    // Returns the suitable version of the image depending on the viewport width.
    var getImageByWidth = function (sizes, targetWidth) {
      var prevImage;

      for (var i = 0, max = sizes.length; i < max; i++) {
        if (sizes[i].width < targetWidth) {
          return prevImage || sizes[i];
        }
        prevImage = sizes[i];
      }
      // Makes sure that smallest is returned if all images bigger than targetWidth.
      return sizes[sizes.length - 1];
    };

    var bgPickerImageSizesContains = function (sizes, url) {
      for (var i = sizes.length; i--; ) {
        if (url.indexOf(sizes[i].url.trim()) > -1) {
          return true;
        }
      }
      return false;
    };

    // Checks the lightness sum of header background image and color and sets the lightness class depending on it's value.
    var bgPickerContentLightnessClass = function (bgPickerArea, combinedLightness) {
      if (combinedLightness >= 0.5) {
        $(bgPickerArea).addClass('light-background').removeClass('dark-background');
      } else {
        $(bgPickerArea).addClass('dark-background').removeClass('light-background');
      }
    };

    // Header background image and color preview logic function.
    var bgPickerPreview = function (bgPickerArea, data, bgPicker) {
      // Defines the variables used in preview logic.

      var bgPickerImagePrevious = $(bgPickerArea).css('background-image'),
        bgPickerImageSuitable = data.imageSizes
          ? getImageByWidth(data.imageSizes, $(window).width())
          : null,
        bgPickerImage =
          data.image && data.image !== '' ? 'url(' + bgPickerImageSuitable.url + ')' : 'none',
        bgPickerImageSizes = data.imageSizes && data.imageSizes !== '' ? data.imageSizes : null,
        bgPickerColor = data.color && data.color !== '' ? data.color : 'rgba(0,0,0,0)';
        data.colorData && data.colorData !== '' ? data.colorData.lightness : 1;
        var colorExtractImage = $('<img>'),
        colorExtractCanvas = $('<canvas>'),
        colorExtractImageUrl = data.image && data.image !== '' ? data.image : null,
        colorRgb;

      if (colorExtractImageUrl) {
        if (bgPickerImageSizesContains(bgPickerImageSizes, bgPickerImagePrevious)) {
          bgPicker.imageColor = bgPicker.imageColor ? bgPicker.imageColor : defaultImageColor;
          bgPicker.combinedLightness = getCombinedLightness(bgPicker.imageColor, bgPickerColor);
          bgPickerContentLightnessClass(bgPickerArea, bgPicker.combinedLightness);
        } else {
          colorExtractImage.attr(
            'src',
            colorExtractImageUrl.replace(/.*\/(photos|voogstock)/g, '/photos')
          );
          colorExtractImage.on('load', function () {
            ColorExtract.extract(colorExtractImage[0], colorExtractCanvas[0], function (data) {
              bgPicker.imageColor = data.bgColor ? data.bgColor : 'rgba(255,255,255,1)';
              bgPicker.combinedLightness = getCombinedLightness(bgPicker.imageColor, bgPickerColor);
              bgPickerContentLightnessClass(bgPickerArea, bgPicker.combinedLightness);
            });
          });
        }
      } else {
        bgPicker.imageColor = 'rgba(255,255,255,1)';
        bgPicker.combinedLightness = getCombinedLightness(bgPicker.imageColor, bgPickerColor);
        bgPickerContentLightnessClass(bgPickerArea, bgPicker.combinedLightness);
      }

      if (data.colorData) {
        colorRgb = data.colorData.r + ',' + data.colorData.g + ',' + data.colorData.b;
      } else {
        colorRgb = '255,255,255';
      }

      // Updates the bgPickerContent background image and background color.
      $(':root').css(`--${data.variableName}`, bgPickerColor);
      $(':root').css(`--${data.variableName}-rgb`, colorRgb);

      $(bgPickerArea).find('.js-background-image').first().css({'background-image': bgPickerImage});
    };

    var normalizeValue = function (value) {
      if (value == null || (typeof value == 'string' && value.match(/^[\\'"]+$/))) {
        return '';
      } else {
        return value;
      }
    };

    // Header background image and color save logic function.
    var bgPickerCommit = function ({dataBgKey, data, dataKey, bgPicker, pageType, blockData}) {
      var commitData = $.extend(true, {}, data);
      commitData.image = data.image || '';
      commitData.imageSizes = normalizeValue(data.imageSizes);
      commitData.color = data.color || '';
      commitData.combinedLightness = bgPicker.combinedLightness;

      var nestedDataKeys = ['faro_common_page_blocks', 'faro_categories_page_sections'];

      if (nestedDataKeys.includes(dataBgKey) && dataKey) {
        blockData[dataKey] = blockData[dataKey] || {};
        blockData[dataKey].background = commitData;
        commitData = blockData;
      }
      if (pageType === 'articlePage') {
        Edicy.articles.currentArticle.setData(dataBgKey, commitData);
      } else if (pageType === 'productPage') {
        siteData.set(dataBgKey, commitData);
      } else {
        pageData.set(dataBgKey, commitData);
      }

      return commitData;
    };

    var colorSum = function (bgColor, fgColor) {
      if (bgColor && fgColor) {
        if (typeof bgColor == 'string') {
          bgColor = bgColor
            .replace(/rgba?\(/, '')
            .replace(/\)/, '')
            .split(',');
          $.each(bgColor, function (n, x) {
            bgColor[n] = +x;
          });
        }
        if (typeof fgColor == 'string') {
          fgColor = fgColor
            .replace(/rgba?\(/, '')
            .replace(/\)/, '')
            .split(',');
          $.each(fgColor, function (n, x) {
            fgColor[n] = +x;
          });
        }
        if (typeof bgColor == 'object' && bgColor.hasOwnProperty('length')) {
          if (bgColor.length == 3) {
            bgColor.push(1.0);
          }
        }
        if (typeof fgColor == 'object' && fgColor.hasOwnProperty('length')) {
          if (fgColor.length == 3) {
            fgColor.push(1.0);
          }
        }
        var result = [0, 0, 0, 0];
        result[3] = 1 - (1 - fgColor[3]) * (1 - bgColor[3]);
        if (result[3] === 0) {
          result[3] = 1e-6;
        }
        result[0] = Math.min(
          (fgColor[0] * fgColor[3]) / result[3] +
            (bgColor[0] * bgColor[3] * (1 - fgColor[3])) / result[3],
          255
        );
        result[1] = Math.min(
          (fgColor[1] * fgColor[3]) / result[3] +
            (bgColor[1] * bgColor[3] * (1 - fgColor[3])) / result[3],
          255
        );
        result[2] = Math.min(
          (fgColor[2] * fgColor[3]) / result[3] +
            (bgColor[2] * bgColor[3] * (1 - fgColor[3])) / result[3],
          255
        );
        return $.map(result, function (e) {
          return Math.floor(e);
        });
      }
    };

    var getCombinedColor = function (bgColor, fgColor) {
      var sum = colorSum(bgColor || [255, 255, 255, 1], fgColor || [255, 255, 255, 1]);
      return sum;
    };

    var getCombinedLightness = function (bgColor, fgColor) {
      var combinedColor = getCombinedColor(bgColor, fgColor);
      var color =
        Math.round(
          (+combinedColor[0] * 0.2126 + +combinedColor[1] * 0.7152 + +combinedColor[2] * 0.0722) /
            2.55
        ) / 100;
      return color;
    };

    var bgPickerColorScheme = function (lightness) {
      if (typeof lightness != 'undefined') {
        if (lightness > 0.6) {
          $('.header-wrapper').addClass('light').removeClass('dark');
        } else {
          $('.header-wrapper').addClass('dark').removeClass('light');
        }
      }
    };

    //==========================================================================
    // Sets site custom data saving fanction variable.
    //==========================================================================
    var bindCustomDataItem = function () {
      $('.js-data-item').each(function () {
        $(this).on('change', function (e) {
          if (e.target.type === 'checkbox') {
            var val = e.target.checked;
          } else {
            var val = e.target.value;
          }
          var dataKey = e.target.dataset.name;
          var dataId = e.target.dataset.id;
          var dataEntity = e.target.dataset.entity;
          var dataReload = e.target.dataset.reload;

          if (dataEntity == 'site') {
            var entityData = new Edicy.CustomData({
              type: 'site',
            });
          } else {
            var entityData = new Edicy.CustomData({
              type: dataEntity,
              id: dataId,
            });
          }

          entityData.set(
            {[dataKey]: val},
            {
              success: function () {
                if (dataReload) {
                  location.reload();
                }
              },
            }
          );
        });
      });
    };

    var bindCustomTexteditorStyles = function () {
      window.edy = window.edy || [];
      edy.push([
        'texteditorStyles',
        {name: 'Button', tagname: 'a', attribute: {href: '#'}, classname: 'custom-btn', toggle: true},
      ]);
    };

    var handleDocument = function () {
      if ($('.form_field-cms input').length) {
        if ($('.form_field-cms input').val().length >= 1) {
          $('.form_field-cms input').closest('.form_field-cms').addClass('with-input');
        } else {
          $('.form_field-cms input').closest('.form_field-cms').removeClass('with-input');
        }
      }

      $(document).ready(function () {
        $('.form_field-cms input').keyup(function (e) {
          if ($(this).val().length >= 1) {
            $(this).closest('.form_field-cms').addClass('with-input');
          } else {
            $(this).closest('.form_field-cms').removeClass('with-input');
          }
        });
      });
    };

    var init = function () {
      bindCustomTexteditorStyles();
      bindCustomDataItem();
      handleDocument();
    };

    // Enables the usage of the initiations outside this file.
    // For example add "<script>site.initBlogPage();</script>" at the end of the "Blog & News" page to initiate blog listing view functions.
    window.site = $.extend(window.site || {}, {
      bgPickerPreview: bgPickerPreview,
      bgPickerCommit: bgPickerCommit,
      bgPickerColorScheme: bgPickerColorScheme,
    });

    // Initiates site wide functions.
    init();
  })(jQuery);

}));
