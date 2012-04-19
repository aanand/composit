
(function(/*! Stitch !*/) {
  if (!this.require) {
    var modules = {}, cache = {};
    var require = function(name, root) {
      var path = expand(root, name), indexPath = expand(path, './index'), module, fn;
      module   = cache[path] || cache[indexPath];
      if (module) {
        return module;
      } else if (fn = modules[path] || modules[path = indexPath]) {
        module = {id: path, exports: {}};
        cache[path] = module.exports;
        fn(module.exports, function(name) {
          return require(name, dirname(path));
        }, module);
        return cache[path] = module.exports;
      } else {
        throw 'module ' + name + ' not found';
      }
    };
    var expand = function(root, name) {
      var results = [], parts, part;
      // If path is relative
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    };
    var dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.require = function(name) {
      return require(name, '');
    };
    this.require.define = function(bundle) {
      for (var key in bundle) {
        modules[key] = bundle[key];
      }
    };
    this.require.modules = modules;
    this.require.cache   = cache;
  }
  return this.require.define;
}).call(this)({
  "flickr": function(exports, require, module) {
(function() {

  exports.search = function(query, callback) {
    var params, url;
    url = 'http://api.flickr.com/services/rest/?jsoncallback=?';
    params = {
      api_key: 'bb0cc7a9132fab50731b647bc0c1cbe4',
      format: 'json',
      method: 'flickr.photos.search',
      media: 'photos',
      sort: 'relevance',
      text: query
    };
    return $.getJSON(url, params, function(data) {
      var photoUrls;
      photoUrls = data.photos.photo.map(function(p) {
        return "http://farm" + p.farm + ".staticflickr.com/" + p.server + "/" + p.id + "_" + p.secret + ".jpg";
      });
      return callback(photoUrls);
    });
  };

}).call(this);

}, "image-loader": function(exports, require, module) {
(function() {
  var ImageLoader;

  ImageLoader = (function() {

    ImageLoader.name = 'ImageLoader';

    function ImageLoader() {
      this.firstImageLoaded = false;
      this.unloadedImages = {};
    }

    ImageLoader.prototype.addImageUrls = function(imageUrls) {
      var _this = this;
      return imageUrls.forEach(function(url) {
        var image;
        image = new Image;
        image.src = url;
        _this.unloadedImages[image.src] = image;
        return image.onload = function() {
          if (_this.stopped) {
            return;
          }
          if (!_this.firstImageLoaded) {
            if (_this.onLoadFirstImage) {
              _this.onLoadFirstImage(image);
            }
            _this.firstImageLoaded = true;
          }
          if (_this.onLoadImage) {
            _this.onLoadImage(image);
          }
          return delete _this.unloadedImages[image.src];
        };
      });
    };

    ImageLoader.prototype.stop = function() {
      var image, src, _ref, _results;
      this.stopped = true;
      _ref = this.unloadedImages;
      _results = [];
      for (src in _ref) {
        image = _ref[src];
        image.src = '';
        _results.push(delete this.unloadedImages[src]);
      }
      return _results;
    };

    return ImageLoader;

  })();

  module.exports = ImageLoader;

}).call(this);

}, "throttler": function(exports, require, module) {
(function() {
  var Throttler,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Throttler = (function() {

    Throttler.name = 'Throttler';

    function Throttler(delay) {
      this.delay = delay;
      this.emit = __bind(this.emit, this);

      this.queue = [];
      this.interval = window.setInterval(this.emit, this.delay);
    }

    Throttler.prototype.write = function(object) {
      return this.queue.push(object);
    };

    Throttler.prototype.emit = function() {
      var object;
      if (object = this.queue.pop()) {
        return this.onEmit(object);
      }
    };

    return Throttler;

  })();

  module.exports = Throttler;

}).call(this);

}, "composition": function(exports, require, module) {
(function() {
  var Composition;

  Composition = (function() {

    Composition.name = 'Composition';

    Composition.fromImage = function(image, width, height) {
      var canvas, canvasRatio, imageRatio, scaleHeight, scaleWidth, x, y;
      canvas = document.createElement('canvas');
      canvas.width = width;
      canvas.height = height;
      imageRatio = image.width / image.height;
      canvasRatio = canvas.width / canvas.height;
      scaleWidth = null;
      scaleHeight = null;
      if (imageRatio > canvasRatio) {
        scaleHeight = canvas.height;
        scaleWidth = scaleHeight * imageRatio;
      } else {
        scaleWidth = canvas.width;
        scaleHeight = scaleWidth / imageRatio;
      }
      x = (canvas.width - scaleWidth) / 2;
      y = (canvas.height - scaleHeight) / 2;
      canvas.getContext('2d').drawImage(image, x, y, scaleWidth, scaleHeight);
      return new Composition(canvas, 1);
    };

    Composition.compose = function(components) {
      var canvas, ctx, currentWeight;
      canvas = document.createElement('canvas');
      canvas.width = components[0].canvas.width;
      canvas.height = components[0].canvas.height;
      ctx = canvas.getContext('2d');
      currentWeight = 0;
      components.forEach(function(c) {
        var newWeight;
        newWeight = c.weight + currentWeight;
        c.render(ctx, c.weight / newWeight);
        return currentWeight = newWeight;
      });
      return new Composition(canvas, currentWeight);
    };

    function Composition(canvas, weight) {
      this.canvas = canvas;
      this.weight = weight;
    }

    Composition.prototype.render = function(ctx, alpha) {
      ctx.globalAlpha = alpha;
      return ctx.drawImage(this.canvas, 0, 0);
    };

    return Composition;

  })();

  module.exports = Composition;

}).call(this);

}, "compositor": function(exports, require, module) {
(function() {
  var Composition, Compositor;

  Composition = require('composition');

  Compositor = (function() {

    Compositor.name = 'Compositor';

    Compositor.prototype.maxComponents = 10;

    function Compositor(canvas) {
      this.canvas = canvas;
      this.width = this.canvas.width;
      this.height = this.canvas.height;
      this.components = [];
    }

    Compositor.prototype.addImage = function(image) {
      var a, b;
      this.components.unshift(Composition.fromImage(image, this.width, this.height));
      if (this.components.length > this.maxComponents) {
        a = this.components.shift();
        b = this.components.shift();
        this.components.unshift(Composition.compose([a, b]));
        this.components = this.components.sortBy(function(c) {
          return c.weight;
        });
      }
      return this.render();
    };

    Compositor.prototype.render = function() {
      var topLevelComp;
      topLevelComp = Composition.compose(this.components);
      topLevelComp.render(this.canvas.getContext('2d'), 1.0);
      if (this.onRender) {
        return this.onRender(topLevelComp.weight);
      }
    };

    return Compositor;

  })();

  module.exports = Compositor;

}).call(this);

}, "composit": function(exports, require, module) {
(function() {
  var Compositor, Flickr, ImageLoader, Throttler;

  Flickr = require('flickr');

  ImageLoader = require('image-loader');

  Throttler = require('throttler');

  Compositor = require('compositor');

  exports.start = function() {
    var canvas, doSearch, doSearchFromQueryString, imageLoader, initialURL, input, popped, spinner, spinnerEl;
    spinner = new Spinner();
    spinnerEl = $(".spinner")[0];
    spinner.spin(spinnerEl);
    imageLoader = null;
    canvas = $('.render canvas')[0];
    input = $('.search *[name=query]');
    if (typeof Touch === 'object') {
      $('.search button').click(function() {
        return input.blur();
      });
    }
    $('.search').submit(function(event) {
      var query;
      event.preventDefault();
      query = input.val();
      window.history.pushState(null, null, '?q=' + window.escape(query));
      if (window._gaq) {
        _gaq.push(['_trackPageview', window.location.pathname + window.location.search]);
      }
      return doSearch(query);
    });
    doSearch = function(query) {
      var compositor, throttler;
      spinner.spin(spinnerEl);
      $('.render, .info').fadeIn();
      $('.num-images').html('&nbsp;');
      canvas.width = $('.render').width();
      canvas.height = canvas.width;
      if (imageLoader) {
        imageLoader.stop();
      }
      imageLoader = new ImageLoader;
      throttler = new Throttler(100);
      compositor = new Compositor(canvas);
      imageLoader.onLoadFirstImage = function() {
        return spinner.stop();
      };
      imageLoader.onLoadImage = function(image) {
        return throttler.write(image);
      };
      throttler.onEmit = function(image) {
        return compositor.addImage(image);
      };
      compositor.onRender = function(numImages) {
        return $('.num-images').text("" + numImages + " image" + (numImages !== 1 ? 's' : ''));
      };
      return Flickr.search(query, function(imageUrls) {
        return imageLoader.addImageUrls(imageUrls);
      });
    };
    doSearchFromQueryString = function() {
      var params, query;
      params = Object.fromQueryString(window.location.search);
      query = params.q;
      if (query) {
        query = query.replace(/\+/g, ' ');
        $('*[name=query]').val(query);
        return doSearch(query);
      }
    };
    popped = window.history.state != null;
    initialURL = window.location.href;
    window.addEventListener('popstate', function(event) {
      var initialPop;
      initialPop = !popped && (window.location.href === initialURL);
      if (initialPop) {
        return;
      }
      return doSearchFromQueryString();
    });
    return doSearchFromQueryString();
  };

}).call(this);

}
});