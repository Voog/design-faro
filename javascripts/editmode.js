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
          data.image && data.image !== '' ? `url(${bgPickerImageSuitable.url})` : 'none',
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
        colorRgb = `${data.colorData.r},${data.colorData.g},${data.colorData.b}`;
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
    var bgPickerCommit = function ({
      bgPicker,
      blockData,
      blockKey,
      data,
      dataBgKey,
      dataKey,
      pageType,
    }) {
      var commitData = $.extend(true, {}, data);
      commitData.image = data.image || '';
      commitData.imageSizes = normalizeValue(data.imageSizes);
      commitData.color = data.color || '';
      commitData.combinedLightness = bgPicker.combinedLightness;

      if (dataBgKey === 'faro_body_blocks' && blockKey && dataKey) {
        const currentBlock = blockData.find(b => String(b.key) === String(blockKey));

        if (currentBlock) {
          currentBlock[dataKey] = commitData;
        }

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

    const bindBlockReorder = ({bodyBlocks, dataKey}) => {
      $('.js-move-button').on('click', e => {
        const $htmlBlocks = $(`.${e.target.dataset.wrapperClass}`);

        const buttonKey = e.target.dataset.key;
        const buttonDirection = e.target.dataset.direction;

        const currentBlock = bodyBlocks.find(block => String(block.key) === String(buttonKey));
        const $currentBlockHtml = $htmlBlocks.filter(`[data-block-key="${buttonKey}"]`);
        const currentIndex = bodyBlocks.indexOf(currentBlock);

        if (buttonDirection === 'up' && currentIndex > 0) {
          const prevIndex = currentIndex - 1;
          const prevHtml = $htmlBlocks[prevIndex];

          bodyBlocks.splice(prevIndex, 0, bodyBlocks.splice(currentIndex, 1)[0]);
          pageData.set(dataKey, bodyBlocks, {
            success: () => {
              $currentBlockHtml.insertBefore($(prevHtml));
            },
          });
        } else if (buttonDirection === 'down' && currentIndex + 1 < bodyBlocks.length) {
          const nextIndex = currentIndex + 1;
          const nextHtml = $htmlBlocks[nextIndex];

          bodyBlocks.splice(nextIndex, 0, bodyBlocks.splice(currentIndex, 1)[0]);
          pageData.set(dataKey, bodyBlocks, {
            success: () => {
              $currentBlockHtml.insertAfter($(nextHtml));
            },
          });
        }
      });
    };

    const bindBlockAdd = ({bodyBlocks, dataKey}) => {
      const MAX_ITERATIONS = 100;

      $('.js-add-block').on('click', e => {
        const blockLayout = e.target.dataset.blockLayout;

        const existingKeys = bodyBlocks.map(block => block.key);

        let newKey = String(existingKeys.length + 1);

        if (existingKeys.includes(String(newKey))) {
          for (let i = 1; i < MAX_ITERATIONS; i++) {
            if (!existingKeys.includes(`${newKey}-${i}`)) {
              newKey = `${newKey}-${i}`;
              break;
            } else if (i === MAX_ITERATIONS - 1) {
              console.error('Could not find unique key for new block');
              return;
            }
          }
        }

        bodyBlocks.push({
          key: newKey,
          layout: blockLayout,
        });

        pageData.set(dataKey, bodyBlocks, {
          success: () => {
            location.reload();
          },
        });
      });
    };

    const bindBlockDelete = ({bodyBlocks, dataKey, deleteConfirmation}) => {
      $('.js-delete-button').on('click', e => {
        if (confirm(deleteConfirmation)) {
          const buttonKey = e.target.dataset.key;
          const currentBlock = bodyBlocks.find(block => String(block.key) === String(buttonKey));
          const currentIndex = bodyBlocks.indexOf(currentBlock);

          bodyBlocks.splice(currentIndex, 1);

          pageData.set(dataKey, bodyBlocks, {
            success: () => {
              $(`.${e.target.dataset.wrapperClass}`)
                .filter(`[data-block-key="${buttonKey}"]`)
                .remove();
            },
          });
        }
      });
    };

    const bindFrontPageLayoutChange = ({currentData, key}) => {
      $('.js-change-layout-select').on('change', e => {
        const newLayout = e.target.value;

        currentData.layout = newLayout;

        pageData.set(key, currentData, {
          success: () => {
            location.reload();
          },
        });
      });
    };

    const bindBlockLayoutChange = ({bodyBlocks, dataKey}) => {
      $('.js-change-layout-select').on('change', e => {
        const targetKey = $(e.target).find(':selected').data('key');
        const newLayout = e.target.value;

        const currentBlock = bodyBlocks.find(block => String(block.key) === String(targetKey));

        currentBlock.layout = newLayout;

        pageData.set(dataKey, bodyBlocks, {
          success: () => {
            location.reload();
          },
        });
      });
    };

    const bindBlockSettingsButton = ({bodyBlocks, dataKey}) => {
      $('.js-settings-checkbox').on('change', e => {
        const targetKey = e.target.dataset.key;
        const settingKey = e.target.dataset.setting;
        const currentBlock = bodyBlocks.find(block => String(block.key) === String(targetKey));

        currentBlock.settings = currentBlock.settings || {};
        currentBlock.settings[settingKey] = e.target.checked;

        pageData.set(dataKey, bodyBlocks);
      });
    };

    const bindBlockActions = ({bodyBlocks, dataKey, deleteConfirmation}) => {
      $(document).ready(() => {
        bindBlockAdd({bodyBlocks, dataKey});
        bindBlockDelete({bodyBlocks, dataKey, deleteConfirmation});
        bindBlockReorder({bodyBlocks, dataKey});
        bindBlockLayoutChange({bodyBlocks, dataKey});
        bindBlockSettingsButton({bodyBlocks, dataKey});
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
      bindBlockActions: bindBlockActions,
      bindFrontPageLayoutChange: bindFrontPageLayoutChange,
    });

    // Initiates site wide functions.
    init();
  })(jQuery);

}));
