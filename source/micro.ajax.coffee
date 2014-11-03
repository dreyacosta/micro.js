"use strict"

utils = require "./micro.utils.coffee"
db    = require "./micro.localstorage.coffee"

DEFAULT =
  TYPE: "GET"
  MIME: "json"

MIME_TYPES =
  json: "application/json"
  form: "application/x-www-form-urlencoded"
  html: "text/html"
  text: "text/plain"

ajax =
  ajaxSettings:
    type         : DEFAULT.TYPE
    async        : true
    cache        : false
    cacheDB      : 'xhrs'
    minutesCached: 5
    success      : (res) ->
    error        : (res) ->
    dataType     : DEFAULT.MIME
    headers      : {}
    crossDomain  : false
    timeout      : 0

  ajax: (options) ->
    @ajaxSettings.headers = {}
    settings = utils.extend {}, @ajaxSettings
    options  = utils.extend settings, options

    if options.cache and _checkCache(options)
      return options.success _checkCache(options)

    options.data = @serialize options

    xhr = new XMLHttpRequest()

    xhr.open options.type, options.url, options.async

    xhr.onload = ->
      if xhr.status >= 200 and xhr.status < 400
        data = _parseResponse xhr, options
        if options.cache then _cacheRequest data, options
        options.success data

    xhr.onerror = ->
      options.error 'error'

    _xhrHeaders xhr, options

    xhr.send options.data
    xhr

  serialize: (options) ->
    data = options.data
    if options.dataType is DEFAULT.MIME
      data = JSON.stringify options.data
    data

# -- Private methods -----------------------------------------------------------
_xhrHeaders = (xhr, options) ->
  options.headers['Content-Type'] = MIME_TYPES[options.dataType] if options.dataType
  options.headers['Accept'] = MIME_TYPES[options.dataType] if options.dataType
  for header of options.headers
    xhr.setRequestHeader header, options.headers[header]
  return

_parseResponse = (xhr, options) ->
  response = xhr
  if options.dataType is DEFAULT.MIME
    response = JSON.parse xhr.responseText
  response

_msToMin = (ms) ->
  ms / 1000 / 60

_cacheNotExpired = (req, expireTime) ->
  true if _msToMin(new Date() - new Date(req.date)) < expireTime

_cacheRequest = (data, options) ->
  item =
    url: options.url
    date: new Date()
    data: data
  xhrData = db.findOne options.cacheDB, url: options.url
  db.update options.cacheDB, xhrData.uuid, item

_checkCache = (options) ->
  cache = db.findOne options.cacheDB, url: options.url
  cache.data if cache and _cacheNotExpired cache, options.minutesCached

module.exports = ajax