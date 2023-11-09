(function (factory) {
  typeof define === 'function' && define.amd ? define(factory) :
  factory();
})((function () { 'use strict';

  // quantize.js, Copyright 2012 Shao-Chung Chen.
  // Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)

  // Basic CoffeeScript port of the (MMCQ) Modified Media Cut Quantization
  // algorithm from the Leptonica library (http://www.leptonica.com/).
  // Return a color map you can use to map original pixels to the reduced palette.
  //
  // Rewritten from the JavaScript port (http://gist.github.com/1104622)
  // developed by Nick Rabinowitz under the MIT license.

  // Generated by CoffeeScript 1.3.3
  var MMCQ, PriorityQueue;

  PriorityQueue = (function() {

    function PriorityQueue(comparator) {
      this.comparator = comparator;
      this.contents = [];
      this.sorted = false;
    }

    PriorityQueue.prototype.sort = function() {
      this.contents.sort(this.comparator);
      return this.sotred = true;
    };

    PriorityQueue.prototype.push = function(obj) {
      this.contents.push(obj);
      return this.sorted = false;
    };

    PriorityQueue.prototype.peek = function(index) {
      if (index == null) {
        index = this.contents.length - 1;
      }
      if (!this.sorted) {
        this.sort();
      }
      return this.contents[index];
    };

    PriorityQueue.prototype.pop = function() {
      if (!this.sorted) {
        this.sort();
      }
      return this.contents.pop();
    };

    PriorityQueue.prototype.size = function() {
      return this.contents.length;
    };

    PriorityQueue.prototype.map = function(func) {
      return this.contents.map(func);
    };

    return PriorityQueue;

  })();

  MMCQ = (function() {
    var ColorBox, ColorMap, cboxFromPixels, getColorIndex, getHisto, medianCutApply;

    MMCQ.sigbits = 5;

    MMCQ.rshift = 8 - MMCQ.sigbits;

    function MMCQ() {
      this.maxIterations = 1000;
      this.fractByPopulations = 0.75;
    }

    getColorIndex = function(r, g, b) {
      return (r << (2 * MMCQ.sigbits)) + (g << MMCQ.sigbits) + b;
    };

    ColorBox = (function() {

      function ColorBox(r1, r2, g1, g2, b1, b2, histo) {
        this.r1 = r1;
        this.r2 = r2;
        this.g1 = g1;
        this.g2 = g2;
        this.b1 = b1;
        this.b2 = b2;
        this.histo = histo;
      }

      ColorBox.prototype.volume = function(forced) {
        if (!this._volume || forced) {
          this._volume = (this.r2 - this.r1 + 1) * (this.g2 - this.g1 + 1) * (this.b2 - this.b1 + 1);
        }
        return this._volume;
      };

      ColorBox.prototype.count = function(forced) {
        var b, g, index, numpix, r, _i, _j, _k, _ref1, _ref3, _ref5;
        if (!this._count_set || forced) {
          numpix = 0;
          for (r = _i = this.r1, _ref1 = this.r2; _i <= _ref1; r = _i += 1) {
            for (g = _j = this.g1, _ref3 = this.g2; _j <= _ref3; g = _j += 1) {
              for (b = _k = this.b1, _ref5 = this.b2; _k <= _ref5; b = _k += 1) {
                index = getColorIndex(r, g, b);
                numpix += this.histo[index] || 0;
              }
            }
          }
          this._count_set = true;
          this._count = numpix;
        }
        return this._count;
      };

      ColorBox.prototype.copy = function() {
        return new ColorBox(this.r1, this.r2, this.g1, this.g2, this.b1, this.b2, this.histo);
      };

      ColorBox.prototype.average = function(forced) {
        var b, bsum, g, gsum, hval, index, mult, r, rsum, total, _i, _j, _k, _ref1, _ref3, _ref5;
        if (!this._average || forced) {
          mult = 1 << (8 - MMCQ.sigbits);
          total = 0;
          rsum = 0;
          gsum = 0;
          bsum = 0;
          for (r = _i = this.r1, _ref1 = this.r2; _i <= _ref1; r = _i += 1) {
            for (g = _j = this.g1, _ref3 = this.g2; _j <= _ref3; g = _j += 1) {
              for (b = _k = this.b1, _ref5 = this.b2; _k <= _ref5; b = _k += 1) {
                index = getColorIndex(r, g, b);
                hval = this.histo[index] || 0;
                total += hval;
                rsum += hval * (r + 0.5) * mult;
                gsum += hval * (g + 0.5) * mult;
                bsum += hval * (b + 0.5) * mult;
              }
            }
          }
          if (total) {
            this._average = [~~(rsum / total), ~~(gsum / total), ~~(bsum / total)];
          } else {
            this._average = [~~(mult * (this.r1 + this.r2 + 1) / 2), ~~(mult * (this.g1 + this.g2 + 1) / 2), ~~(mult * (this.b1 + this.b2 + 1) / 2)];
          }
        }
        return this._average;
      };

      ColorBox.prototype.contains = function(pixel) {
        var b, g, r;
        r = pixel[0] >> MMCQ.rshift;
        g = pixel[1] >> MMCQ.rshift;
        b = pixel[2] >> MMCQ.rshift;
        return ((this.r1 <= r && r <= this.r2)) && ((this.g1 <= g && g <= this.g2)) && ((this.b1 <= b && b <= this.b2));
      };

      return ColorBox;

    })();

    ColorMap = (function() {

      function ColorMap() {
        this.cboxes = new PriorityQueue(function(a, b) {
          var va, vb;
          va = a.count() * a.volume();
          vb = b.count() * b.volume();
          if (va > vb) {
            return 1;
          } else if (va < vb) {
            return -1;
          } else {
            return 0;
          }
        });
      }

      ColorMap.prototype.push = function(cbox) {
        return this.cboxes.push({
          cbox: cbox,
          color: cbox.average()
        });
      };

      ColorMap.prototype.palette = function() {
        return this.cboxes.map(function(cbox) {
          return cbox.color;
        });
      };

      ColorMap.prototype.size = function() {
        return this.cboxes.size();
      };

      ColorMap.prototype.map = function(color) {
        var i, _i, _ref;
        for (i = _i = 0, _ref = this.cboxes.size(); _i < _ref; i = _i += 1) {
          if (this.cboxes.peek(i).cbox.contains(color)) {
            return this.cboxes.peek(i).color;
          }
          return this.nearest(color);
        }
      };

      ColorMap.prototype.cboxes = function() {
        return this.cboxes;
      };

      ColorMap.prototype.nearest = function(color) {
        var dist, i, minDist, retColor, square, _i, _ref;
        square = function(n) {
          return n * n;
        };
        minDist = 1e9;
        for (i = _i = 0, _ref = this.cboxes.size(); _i < _ref; i = _i += 1) {
          dist = Math.sqrt(square(color[0] - this.cboxes.peek(i).color[0]) + square(color[1] - this.cboxes.peek(i).color[1]) + square(color[2] - this.cboxes.peek(i).color[2]));
          if (dist < minDist) {
            minDist = dist;
            retColor = this.cboxes.peek(i).color;
          }
        }
        return retColor;
      };

      return ColorMap;

    })();

    getHisto = function(pixels) {
      var b, g, histo, histosize, index, pixel, r, _i, _len;
      histosize = 1 << (3 * MMCQ.sigbits);
      histo = new Array(histosize);
      for (_i = 0, _len = pixels.length; _i < _len; _i++) {
        pixel = pixels[_i];
        r = pixel[0] >> MMCQ.rshift;
        g = pixel[1] >> MMCQ.rshift;
        b = pixel[2] >> MMCQ.rshift;
        index = getColorIndex(r, g, b);
        histo[index] = (histo[index] || 0) + 1;
      }
      return histo;
    };

    cboxFromPixels = function(pixels, histo) {
      var b, bmax, bmin, g, gmax, gmin, pixel, r, rmax, rmin, _i, _len;
      rmin = 1e6;
      rmax = 0;
      gmin = 1e6;
      gmax = 0;
      bmin = 1e6;
      bmax = 0;
      for (_i = 0, _len = pixels.length; _i < _len; _i++) {
        pixel = pixels[_i];
        r = pixel[0] >> MMCQ.rshift;
        g = pixel[1] >> MMCQ.rshift;
        b = pixel[2] >> MMCQ.rshift;
        if (r < rmin) {
          rmin = r;
        } else if (r > rmax) {
          rmax = r;
        }
        if (g < gmin) {
          gmin = g;
        } else if (g > gmax) {
          gmax = g;
        }
        if (b < bmin) {
          bmin = b;
        } else if (b > bmax) {
          bmax = b;
        }
      }
      return new ColorBox(rmin, rmax, gmin, gmax, bmin, bmax, histo);
    };

    medianCutApply = function(histo, cbox) {
      var b, bw, doCut, g, gw, index, lookaheadsum, maxw, partialsum, r, rw, sum, total, _i, _j, _k, _l, _m, _n, _o, _p, _q, _ref1, _ref11, _ref13, _ref15, _ref17, _ref3, _ref5, _ref7, _ref9;
      if (!cbox.count()) {
        return;
      }
      if (cbox.count() === 1) {
        return [cbox.copy()];
      }
      rw = cbox.r2 - cbox.r1 + 1;
      gw = cbox.g2 - cbox.g1 + 1;
      bw = cbox.b2 - cbox.b1 + 1;
      maxw = Math.max(rw, gw, bw);
      total = 0;
      partialsum = [];
      lookaheadsum = [];
      if (maxw === rw) {
        for (r = _i = cbox.r1, _ref1 = cbox.r2; _i <= _ref1; r = _i += 1) {
          sum = 0;
          for (g = _j = cbox.g1, _ref3 = cbox.g2; _j <= _ref3; g = _j += 1) {
            for (b = _k = cbox.b1, _ref5 = cbox.b2; _k <= _ref5; b = _k += 1) {
              index = getColorIndex(r, g, b);
              sum += histo[index] || 0;
            }
          }
          total += sum;
          partialsum[r] = total;
        }
      } else if (maxw === gw) {
        for (g = _l = cbox.g1, _ref7 = cbox.g2; _l <= _ref7; g = _l += 1) {
          sum = 0;
          for (r = _m = cbox.r1, _ref9 = cbox.r2; _m <= _ref9; r = _m += 1) {
            for (b = _n = cbox.b1, _ref11 = cbox.b2; _n <= _ref11; b = _n += 1) {
              index = getColorIndex(r, g, b);
              sum += histo[index] || 0;
            }
          }
          total += sum;
          partialsum[g] = total;
        }
      } else {
        for (b = _o = cbox.b1, _ref13 = cbox.b2; _o <= _ref13; b = _o += 1) {
          sum = 0;
          for (r = _p = cbox.r1, _ref15 = cbox.r2; _p <= _ref15; r = _p += 1) {
            for (g = _q = cbox.g1, _ref17 = cbox.g2; _q <= _ref17; g = _q += 1) {
              index = getColorIndex(r, g, b);
              sum += histo[index] || 0;
            }
          }
          total += sum;
          partialsum[b] = total;
        }
      }
      partialsum.forEach(function(d, i) {
        return lookaheadsum[i] = total - d;
      });
      doCut = function(color) {
        var cbox1, cbox2, count2, d2, dim1, dim2, i, left, right, _r, _ref19;
        dim1 = color + '1';
        dim2 = color + '2';
        for (i = _r = cbox[dim1], _ref19 = cbox[dim2]; _r <= _ref19; i = _r += 1) {
          if (partialsum[i] > (total / 2)) {
            cbox1 = cbox.copy();
            cbox2 = cbox.copy();
            left = i - cbox[dim1];
            right = cbox[dim2] - i;
            if (left <= right) {
              d2 = Math.min(cbox[dim2] - 1, ~~(i + right / 2));
            } else {
              d2 = Math.max(cbox[dim1], ~~(i - 1 - left / 2));
            }
            while (!partialsum[d2]) {
              d2++;
            }
            count2 = lookaheadsum[d2];
            while (!count2 && partialsum[d2 - 1]) {
              count2 = lookaheadsum[--d2];
            }
            cbox1[dim2] = d2;
            cbox2[dim1] = cbox1[dim2] + 1;
            // console.log("cbox counts: " + (cbox.count()) + ", " + (cbox1.count()) + ", " + (cbox2.count()));
            return [cbox1, cbox2];
          }
        }
      };
      if (maxw === rw) {
        return doCut("r");
      }
      if (maxw === gw) {
        return doCut("g");
      }
      if (maxw === bw) {
        return doCut("b");
      }
    };

    MMCQ.prototype.quantize = function(pixels, maxcolors) {
      var cbox, cmap, histo, iter, pq, pq2,
        _this = this;
      if ((!pixels.length) || (maxcolors < 2) || (maxcolors > 256)) {
        console.log("invalid arguments");
        return false;
      }
      histo = getHisto(pixels);
      cbox = cboxFromPixels(pixels, histo);
      pq = new PriorityQueue(function(a, b) {
        var va, vb;
        va = a.count();
        vb = b.count();
        if (va > vb) {
          return 1;
        } else if (va < vb) {
          return -1;
        } else {
          return 0;
        }
      });
      pq.push(cbox);
      iter = function(lh, target) {
        var cbox1, cbox2, cboxes, ncolors, niters;
        ncolors = 1;
        niters = 0;
        while (niters < _this.maxIterations) {
          cbox = lh.pop();
          if (!cbox.count()) {
            lh.push(cbox);
            niters++;
            continue;
          }
          cboxes = medianCutApply(histo, cbox);
          cbox1 = cboxes[0];
          cbox2 = cboxes[1];
          if (!cbox1) {
            console.log("cbox1 not defined; shouldn't happen");
            return;
          }
          lh.push(cbox1);
          if (cbox2) {
            lh.push(cbox2);
            ncolors++;
          }
          if (ncolors >= target) {
            return;
          }
          if ((niters++) > _this.maxIterations) {
            console.log("infinite loop; perhaps too few pixels");
            return;
          }
        }
      };
      iter(pq, this.fractByPopulations * maxcolors);
      pq2 = new PriorityQueue(function(a, b) {
        var va, vb;
        va = a.count() * a.volume();
        vb = b.count() * b.volume();
        if (va > vb) {
          return 1;
        } else if (va < vb) {
          return -1;
        } else {
          return 0;
        }
      });
      while (pq.size()) {
        pq2.push(pq.pop());
      }
      iter(pq2, maxcolors - pq2.size());
      cmap = new ColorMap;
      while (pq2.size()) {
        cmap.push(pq2.pop());
      }
      return cmap;
    };

    return MMCQ;

  }).call(undefined);

  // Generated by CoffeeScript 1.6.3
  (function() {
    window.ColorExtract = (function() {
      function ColorExtract() {}

      ColorExtract.getColorMap = function(canvas, sx, sy, w, h, nc) {
        var index, indexBase, pdata, pixels, x, y, _i, _j, _ref, _ref1;
        if (nc == null) {
          nc = 8;
        }
        pdata = canvas.getContext("2d").getImageData(sx, sy, w, h).data;
        pixels = [];
        for (y = _i = sy, _ref = sy + h; _i < _ref; y = _i += 1) {
          indexBase = y * w * 4;
          for (x = _j = sx, _ref1 = sx + w; _j < _ref1; x = _j += 1) {
            index = indexBase + (x * 4);
            pixels.push([pdata[index], pdata[index + 1], pdata[index + 2]]);
          }
        }
        return (new MMCQ).quantize(pixels, nc);
      };

      ColorExtract.colorDist = function(a, b) {
        var square;
        square = function(n) {
          return n * n;
        };
        return square(a[0] - b[0]) + square(a[1] - b[1]) + square(a[2] - b[2]);
      };

      ColorExtract.extract = function(image, canvas, callback) {
        var bgColor, bgColorMap, bgPalette, color, dist, fgColor, fgColor2, fgColorMap, fgPalette, maxDist, rgbToCssString, _i, _j, _len, _len1;
        canvas.width = 25;
        canvas.height = 25;
        canvas.getContext("2d").drawImage(image, 0, 0, canvas.width, canvas.height);
        bgColorMap = ColorExtract.getColorMap(canvas, 0, 0, canvas.width, canvas.height, 4);
        bgPalette = bgColorMap.cboxes.map(function(cbox) {
          return {
            count: cbox.cbox.count(),
            rgb: cbox.color
          };
        });
        bgPalette.sort(function(a, b) {
          return b.count - a.count;
        });
        bgColor = bgPalette[0].rgb;
        fgColorMap = ColorExtract.getColorMap(canvas, 0, 0, image.width, image.height, 10);
        fgPalette = fgColorMap.cboxes.map(function(cbox) {
          return {
            count: cbox.cbox.count(),
            rgb: cbox.color
          };
        });
        fgPalette.sort(function(a, b) {
          return b.count - a.count;
        });
        maxDist = 0;
        for (_i = 0, _len = fgPalette.length; _i < _len; _i++) {
          color = fgPalette[_i];
          dist = ColorExtract.colorDist(bgColor, color.rgb);
          if (dist > maxDist) {
            maxDist = dist;
            fgColor = color.rgb;
          }
        }
        maxDist = 0;
        for (_j = 0, _len1 = fgPalette.length; _j < _len1; _j++) {
          color = fgPalette[_j];
          dist = ColorExtract.colorDist(bgColor, color.rgb);
          if (dist > maxDist && color.rgb !== fgColor) {
            maxDist = dist;
            fgColor2 = color.rgb;
          }
        }
        rgbToCssString = function(color) {
          return "rgb(" + color[0] + ", " + color[1] + ", " + color[2] + ")";
        };
        return callback({
          bgColor: rgbToCssString(bgColor),
          fgColor: rgbToCssString(fgColor),
          fgColor2: rgbToCssString(fgColor2)
        });
      };

      return ColorExtract;

    })();

  }).call(undefined);

  (function ($) {
    // ===========================================================================
    // Binds site search functionality.
    // ===========================================================================
    var bindSiteSearch = function (searchForm, languageCode, noResultsString) {
      if (searchForm) {
        new VoogSearch(searchForm, {
          // This defines the number of results per query.
          per_page: 10,
          // Language code for restricting the search to page language.
          lang: languageCode,
          // If given, an DOM element results are rendered inside that element
          resultsContainer: $('.js-voog-search-modal-inner').get(0),
          // Defines if modal should close on sideclick.
          sideclick: false,
          // Mobile checkpoint
          mobileModeWidth: 900,
          // Updates results on every keypress.
          updateOnKeypress: true,
          // String for feedback if no results are found.
          noResults: noResultsString,
        });

        $(searchForm).on('sitesearch:showmodal', () => {
          if ($(window).width() <= 900) {
            $('.js-menu-main').addClass('search-modal-active');
          }
        });

        $(searchForm).on('sitesearch:hidemodal', () => {
          if ($(window).width() <= 900) {
            $('.js-menu-main').removeClass('search-modal-active');
          }
        });
      }
    };

    // Function to limit the rate at which a function can fire.
    const debounce = (func, wait, immediate) => {
      let timeout;

      return function () {
        const context = this,
          args = arguments;
        let later = function () {
          timeout = null;
          if (!immediate) func.apply(context, args);
        };
        let callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) {
          func.apply(context, args);
        }
      };
    };

    const bindSideClicks = () => {
      $('.container').on('mousedown', function (event) {
        if (!$(event.target).closest('.js-prevent-sideclick').length) {
          $('.js-popover').removeClass('expanded');
          $('.js-search-close-btn').trigger('click');
          $('.js-image-settings-popover').toggleClass('active');
        }
      });
    };

    const handleMenuContent = () => {
      const $mainMenu = $('.js-menu-main');
      const $dropdownMenu = $mainMenu.find('.dropdown-menu, .dropdown-menu-visible');
      const $dropdownContent = $dropdownMenu.find('.dropdown-menu-children');

      const $menu = $mainMenu.find('.menu').append($dropdownContent.children());
      const $menuItems = $menu.find('.menu-item-wrapper');
      const items = [];

      $menuItems.each((idx, item) => {
        const isOverflowing = item.offsetTop > 0;

        // Make sure that atleast 1 menu element is visuble in addition to dropdown icon
        if (idx >= 1 && isOverflowing) {
          // Push last visible item to dropdown to make room for dropdown icon
          if (items.length === 0 && idx >= 2) {
            items.push($($menuItems[idx - 1]));
          }
          items.push($(item));
        }
      });

      if (items.length > 0) {
        $dropdownContent.append(items);
        $dropdownMenu.append($dropdownContent);
        $menu.append($dropdownMenu);
        $dropdownMenu.removeClass('dropdown-menu').addClass('dropdown-menu-visible');
      }
    };

    const handleMobileMenuContent = () => {
      const $menu = $('.js-menu-main .menu');
      const $menuItems = $menu.find('.menu-item-wrapper:not(.menu-lang-wrapper)');

      $menuItems.each((_, item) => {
        $menu.append($(item));
      });
    };

    const buildCustomShoppingCartIcon = () => {
      // Emitted when the shopping cart button element is added to the DOM.
      $(document).on('voog:shoppingcart:button:created', () => {
        if (getCartItemsCount() >= 1) {
          $('.cart-btn').addClass('active');
          $('.cart-btn .cart-btn-count').text(getCartItemsCount());
        }
      });
    };

    const getCartItemsCount = () => {
      const shoppingCart = Voog.ShoppingCart;

      return shoppingCart
        ? shoppingCart.getContents().items.reduce((acc, item) => acc + item.quantity, 0)
        : 0;
    };

    const handleProductCountChange = (e, addProduct) => {
      const itemsCount = getCartItemsCount();
      const $cartBtn = $('.cart-btn');
      const $counterElement = $('.cart-btn .cart-btn-count');
      const prevCount = parseInt($counterElement.text()) || 0;
      const isCartModalOpen = $('.edy-ecommerce-modal-open').length >= 1;
      let timer;

      if (itemsCount >= 1 || addProduct) {
        if (timer != null) {
          clearTimeout(timer);
        }

        if (itemsCount > prevCount && !isCartModalOpen) {
          const currentLanguage = $('html').attr('lang');
          let productName = e.detail.product_name;

          if (
            Object.prototype.hasOwnProperty.call(e.detail, 'translations') &&
            Object.prototype.hasOwnProperty.call(e.detail.translations, 'name') &&
            Object.prototype.hasOwnProperty.call(e.detail.translations.name, currentLanguage)
          ) {
            productName = e.detail.translations.name[currentLanguage];
          }

          $('.cart-popover .product-name').text(productName);
          $(':not(body.edy-ecommerce-modal-open) .cart-popover').addClass('visible');

          timer = setTimeout(function () {
            $('.cart-popover').removeClass('visible');
          }, 3000);
        }

        $cartBtn.addClass('active');
        $counterElement.text(itemsCount);
      } else {
        $cartBtn.removeClass('active');
        $counterElement.text('');
      }
    };

    const handleProductCountSync = () => {
      const itemsCount = getCartItemsCount();
      const $cartBtn = $('.cart-btn');
      const $counterElement = $('.cart-btn .cart-btn-count');

      if (itemsCount >= 1) {
        $cartBtn.addClass('active');
        $counterElement.text(itemsCount);
      } else {
        $cartBtn.removeClass('active');
        $counterElement.text('');
      }
    };

    const handleShoppingCartEvents = () => {
      // Emitted when a product is removed from the shopping cart
      $(document).on('voog:shoppingcart:removeproduct', e => {
        handleProductCountChange(e, false);
      });

      // Emitted when a product's quantity changes
      $(document).on('voog:shoppingcart:changequantity', e => {
        handleProductCountChange(e, true);
      });

      // Emitted when a new product is added to the cart
      $(document).on('voog:shoppingcart:addproduct', e => {
        handleProductCountChange(e, true);
      });

      $(document).on('voog:shoppingcart:contentschanged', () => {
        handleProductCountSync();
      });

      $('.cart-btn, .cart-popover').click(() => {
        if (getCartItemsCount() >= 1) {
          Voog.ShoppingCart.showCart();
        }
      });
    };

    const handleCategoriesPageContent = () => {
      const headerHeight = $('.js-header').height();
      const $categoriesPageContent = $('.js-category-section');

      $categoriesPageContent.css('height', `calc(calc(100vh - ${headerHeight}px)`);
    };

    const handleHeaderContent = callback => {
      const $header = $('.js-header .header');
      const $headerRight = $header.find('.header-right');
      const $menuMain = $header.find('.js-menu-main .menu');

      if ($(window).width() > 900) {
        $header.append($headerRight);
      } else {
        $menuMain.append($headerRight);
      }

      callback();
    };

    const handleMenus = () => {
      if ($(window).width() > 900) {
        handleMenuContent();
      } else {
        handleMobileMenuContent();
      }
    };

    const handleMenuPadding = () => {
      if ($(window).width() > 900) {
        $('.js-menu-main .menu .menu-item-wrapper').first().css('padding-top', '');
        $('.js-menu-main .menu-item-children, .menu-lang .menu-item-children').css('padding-top', '');
        $('.search').css('padding-top', '');
      } else {
        const headerHeight = $('.js-header').height();

        $('.js-menu-main .menu div:visible').first().css('padding-top', `${headerHeight}px`);
        $('.js-menu-main .menu-item-children').css('padding-top', `${headerHeight}px`);
      }
    };

    const handleSearchPosition = () => {
      const $search = $('.search');

      if ($(window).width() > 900) {
        $('.header-right').prepend($search);
      } else {
        $('.menu').prepend($search);
      }
    };

    const bindMobileMenuBtnClick = () => {
      $('.js-menu-main .mobile-menu-button').click(() => {
        if ($('.js-header').hasClass('menu-active')) {
          $('.js-header').removeClass('menu-children-active menu-active');
          $('.js-header .menu-item-wrapper.has-children').removeClass('active');

          setTimeout(() => {
            $('.js-header .menu-item-children').removeClass('active');
          }, 1000);
        } else {
          $('.js-header').addClass('menu-active');
        }
      });

      $('.js-menu-main .menu-children-icon, .menu-lang .menu-children-icon').click(e => {
        $(e.target).closest('.menu-item-wrapper.has-children').addClass('active');
        $(e.target.parentElement).find('.menu-item-children').addClass('active');
        $('.js-header').addClass('menu-children-active');

        // Scroll menu to top when opening menu children
        $('.js-menu-main .menu').scrollTop(0);
      });

      $('.menu-lang .menu-children-icon').click(() => {
        $('.header-right').addClass('active');
      });

      $('.js-header .menu-children-close-icon').click(() => {
        $('.menu-item-wrapper.has-children').removeClass('active');
        $('.menu-item-children').removeClass('active');
        $('.js-header').removeClass('menu-children-active');

        setTimeout(() => {
          $('.header-right').removeClass('active');
        }, 1000);
      });
    };

    const bindSearchBtnClick = () => {
      $('.js-search-modal-open-btn').click(() => {
        $('.js-search').addClass('active');
      });

      $('.js-search-modal-close-btn').click(() => {
        $('.js-search').removeClass('active');
      });
    };

    const handleWindowResize = () => {
      let prevWindowWidth = $(window).width();

      $(document).ready(() => {
        handleMenus();
        handleSearchPosition();
        handleHeaderContent(() => {
          handleMenuPadding();
          handleCategoriesPageContent();
        });
      });

      $(window).resize(
        debounce(() => {
          const newWindowWidth = $(window).width();

          if (newWindowWidth !== prevWindowWidth) {
            handleMenus();
            handleSearchPosition();
            handleHeaderContent(() => {
              handleMenuPadding();
            });

            prevWindowWidth = newWindowWidth;
          }
        }, 250)
      );
    };

    const init = () => {
      bindSideClicks();
      handleWindowResize();
      handleShoppingCartEvents();
      buildCustomShoppingCartIcon();
      bindMobileMenuBtnClick();
      bindSearchBtnClick();

      $(window).ready(() => {
        if (window.VoogEcommerce) {
          $('.cart-btn').css('display', 'flex');
        }
      });
    };

    window.site = $.extend(window.site || {}, {
      bindSiteSearch: bindSiteSearch,
    });

    init();
  })(jQuery);

}));
