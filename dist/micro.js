(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';
var ajax, db, utils, _cacheNotExpired, _cacheRequest, _checkCache, _msToMin, _parseResponse, _xhrHeaders;

utils = require('./micro.utils.coffee');

db = require('./micro.localstorage.coffee');

_xhrHeaders = function(xhr, options) {
  var header;
  if (options.contentType) {
    options.headers['Content-Type'] = options.contentType;
  }
  if (options.contentType) {
    options.headers['Accept'] = options.contentType;
  }
  for (header in options.headers) {
    xhr.setRequestHeader(header, options.headers[header]);
  }
};

_parseResponse = function(xhr, options) {
  var response;
  response = xhr;
  if (options.contentType === 'application/json') {
    response = JSON.parse(xhr.responseText);
  }
  return response;
};

_msToMin = function(ms) {
  return ms / 1000 / 60;
};

_cacheNotExpired = function(req, expireTime) {
  if (_msToMin(new Date() - new Date(req.date)) < expireTime) {
    return true;
  }
};

_cacheRequest = function(data, options) {
  var item;
  item = {
    url: options.url,
    date: new Date(),
    data: data
  };
  return db.update(options.cacheDB, 'url', options.url, item);
};

_checkCache = function(options) {
  var cache;
  cache = db.findOne(options.cacheDB, {
    url: options.url
  });
  if (cache && _cacheNotExpired(cache, options.minutesCached)) {
    return cache.data;
  }
};

ajax = {
  ajaxSettings: {
    type: 'GET',
    async: true,
    cache: false,
    cacheDB: 'ajaxRequests',
    minutesCached: 5,
    success: function(res) {},
    error: function(res) {},
    contentType: 'application/json',
    headers: {},
    crossDomain: false,
    timeout: 0
  },
  ajax: function(options) {
    var req, settings;
    settings = utils.extend({}, this.ajaxSettings);
    options = utils.extend(settings, options);
    if (options.cache && _checkCache(options)) {
      return options.success(_checkCache(options));
    }
    options.data = this.serialize(options);
    req = new XMLHttpRequest();
    req.open(options.type, options.url, options.async);
    req.onload = function() {
      var data;
      if (req.status >= 200 && req.status < 400) {
        data = _parseResponse(req, options);
        if (options.cache) {
          _cacheRequest(data, options);
        }
        return options.success(data);
      }
    };
    req.onerror = function() {
      return options.error('error');
    };
    _xhrHeaders(req, options);
    req.send(options.data);
    return req;
  },
  serialize: function(options) {
    var data;
    data = options.data;
    if (options.contentType === 'application/json') {
      data = JSON.stringify(options.data);
    }
    return data;
  }
};

module.exports = ajax;


},{"./micro.localstorage.coffee":5,"./micro.utils.coffee":6}],2:[function(require,module,exports){
var ajax, dom, exports, localstorage, u, utils;

u = require('./micro.core.coffee');

dom = require('./micro.dom.coffee');

utils = require('./micro.utils.coffee');

localstorage = require('./micro.localstorage.coffee');

ajax = require('./micro.ajax.coffee');

utils.extend(u.prototype, dom);

utils.extend(u, utils, {
  db: localstorage
}, ajax);

if (typeof module !== 'undefined') {
  if (module.exports) {
    exports = module.exports = u;
  }
  exports.u = u;
}

if (typeof window !== 'undefined') {
  window.u = u;
}


},{"./micro.ajax.coffee":1,"./micro.core.coffee":3,"./micro.dom.coffee":4,"./micro.localstorage.coffee":5,"./micro.utils.coffee":6}],3:[function(require,module,exports){
'use strict';
var exports, forEach, push, slice, u;

forEach = Array.prototype.forEach;

push = Array.prototype.push;

slice = Array.prototype.slice;

u = function(selector) {
  if (!(this instanceof u)) {
    return new u(selector);
  }
  if (!selector) {
    return this;
  }
  if (selector instanceof u) {
    return selector;
  }
  if (typeof selector === 'string') {
    return push.apply(this, slice.call(document.querySelectorAll(selector)));
  }
  if (typeof selector === 'function') {
    return u(document).ready(selector);
  }
};

u.prototype = {
  length: 0
};

u.VERSION = '0.0.1';

if (typeof module !== 'undefined') {
  if (module.exports) {
    exports = module.exports = u;
  }
  exports.u = u;
}

if (typeof window !== 'undefined') {
  window.u = u;
}

module.exports = u;


},{}],4:[function(require,module,exports){
'use strict';
var forEach, manipulationsMethods, push, slice;

forEach = Array.prototype.forEach;

push = Array.prototype.push;

slice = Array.prototype.slice;

manipulationsMethods = {
  each: function(callback) {
    forEach.call(this, function(el, idx) {
      return callback.call(el, idx);
    });
    return this;
  },
  ready: function(callback) {
    if (document.readyState === 'complete') {
      callback(u);
    }
    return document.addEventListener('DOMContentLoaded', function() {
      return callback(u);
    });
  },
  text: function(value) {
    if (value === void 0) {
      return this[0].textContent;
    }
    return this.each(function() {
      return this.textContent = value;
    });
  },
  find: function(selector) {
    var results;
    results = new u();
    this.each(function() {
      window.el = this;
      return push.apply(results, slice.call(this.querySelectorAll(selector)));
    });
    return results;
  },
  html: function(value) {
    if (value === void 0) {
      return this[0].innerHTML;
    }
    return this.each(function() {
      return this.innerHTML = value;
    });
  },
  append: function(el) {
    return this.each(function() {
      return this.appendChild(el);
    });
  },
  prepend: function(el) {
    return this.each(function() {
      return this.insertBefore(el, this.firstChild);
    });
  },
  on: function(type, func) {
    return this.each(function() {
      return this.addEventListener(type, func);
    });
  },
  off: function(type, func) {
    return this.each(function() {
      return this.removeEventListener(type, func);
    });
  }
};

module.exports = manipulationsMethods;


},{}],5:[function(require,module,exports){
'use strict';
var localDB, _filter, _filterOne, _matches;

_filter = function(obj, predicate) {
  var item, result, _i, _len;
  result = [];
  for (_i = 0, _len = obj.length; _i < _len; _i++) {
    item = obj[_i];
    if (predicate(item)) {
      result.push(item);
    }
  }
  return result;
};

_filterOne = function(obj, predicate) {
  var item, _i, _len;
  for (_i = 0, _len = obj.length; _i < _len; _i++) {
    item = obj[_i];
    if (predicate(item)) {
      return item;
    }
  }
  return false;
};

_matches = function(attrs) {
  return function(obj) {
    var key, val;
    for (key in attrs) {
      val = attrs[key];
      if (attrs[key] !== obj[key]) {
        return false;
      }
    }
    return true;
  };
};

localDB = {
  data: {},
  _checkCollection: function(collection) {
    return this.data[collection] = this.data[collection] ? this.data[collection] : [];
  },
  get: function(collection) {
    if (localStorage.getItem(collection)) {
      return this.data[collection] = JSON.parse(localStorage.getItem(collection));
    }
  },
  clear: function(collection) {
    delete this.data[collection];
    return localStorage.removeItem(collection);
  },
  write: function(collection) {
    return localStorage.setItem(collection, JSON.stringify(this.data[collection]));
  },
  save: function(collection, data) {
    var items;
    items = this._checkCollection(collection);
    items.push(data);
    this.write(collection);
    return data;
  },
  findOne: function(collection, attrs) {
    if (this.data[collection]) {
      return _filterOne(this.data[collection], _matches(attrs));
    }
  },
  find: function(collection, attrs) {
    if (this.data[collection]) {
      return _filter(this.data[collection], _matches(attrs));
    }
  },
  update: function(collection, key, value, attrs) {
    var data, item, items, val, _i, _len;
    items = this._checkCollection(collection);
    if (items.length === 0) {
      items.push(attrs);
    }
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      if (item[key] === value) {
        data = item;
      }
    }
    for (key in attrs) {
      val = attrs[key];
      data[key] = val;
    }
    this.write(collection);
    return data;
  },
  remove: function(collection, key, value) {
    var index, item, items, _i, _len;
    items = this._checkCollection(collection);
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      if (item[key] === value) {
        index = items.indexOf(item);
      }
    }
    if (index > -1) {
      items.splice(index, 1);
    }
    return this.write(collection);
  }
};

module.exports = localDB;


},{}],6:[function(require,module,exports){
'use strict';
var utils;

utils = {
  subscribers: {},
  subscribe: function(topic, func) {
    if (!this.subscribers[topic]) {
      this.subscribers[topic] = [];
    }
    if (this.subscribers[topic].indexOf(func) === -1) {
      this.subscribers[topic].push(func);
    }
  },
  unsubscribe: function(topic, func) {
    var index, listeners;
    listeners = this.subscribers[topic];
    if (!listeners) {
      return;
    }
    index = listeners.indexOf(func);
    if (index > -1) {
      listeners.splice(index, 1);
    }
  },
  publish: function(topic, eventObj) {
    var listener, listeners, _i, _len, _results;
    if (!this.subscribers[topic]) {
      return false;
    }
    if (!eventObj.type) {
      eventObj.type = topic;
    }
    listeners = this.subscribers[topic];
    _results = [];
    for (_i = 0, _len = listeners.length; _i < _len; _i++) {
      listener = listeners[_i];
      _results.push(listener(eventObj));
    }
    return _results;
  },
  extend: function(obj) {
    var args;
    args = Array.prototype.slice.call(arguments, 1);
    args.forEach(function(source) {
      var method, _results;
      _results = [];
      for (method in source) {
        _results.push(obj[method] = source[method]);
      }
      return _results;
    });
    return obj;
  }
};

module.exports = utils;


},{}]},{},[2])