do ->
  'use strict'

  u = module.exports.u if typeof module isnt 'undefined'
  u = window.u if typeof window isnt 'undefined'
  u = {} if typeof u is 'undefined'

  _xhrHeaders = (xhr, options) ->
    options.headers['Content-Type'] = options.contentType if options.contentType
    options.headers['Accept'] = options.contentType if options.contentType
    for header of options.headers
      xhr.setRequestHeader header, options.headers[header]
    return

  _parseResponse = (xhr, options) ->
    response = xhr
    if options.contentType is 'application/json'
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
    u.db.update options.cacheDB, 'url', options.url, item

  _checkCache = (options) ->
    cache = u.db.findOne options.cacheDB, url: options.url
    cache.data if cache and _cacheNotExpired cache, options.minutesCached

  u.ajaxSettings =
    type: 'GET'
    async: true
    cache: false
    cacheDB: 'ajaxRequests'
    minutesCached: 5
    success: (res) ->
    error: (res) ->
    contentType : 'application/json'
    headers: {}
    crossDomain: false
    timeout: 0

  u.ajax = (options) ->
    settings = u.extend {}, u.ajaxSettings
    options  = u.extend settings, options

    if options.cache and _checkCache(options)
      return options.success _checkCache(options)

    options.data = u.serialize(options)

    req = new XMLHttpRequest()

    req.open options.type, options.url, options.async

    req.onload = ->
      if req.status >= 200 and req.status < 400
        data = _parseResponse req, options
        if options.cache then _cacheRequest data, options
        options.success data

    req.onerror = ->
      options.error 'error'

    _xhrHeaders req, options

    req.send options.data
    req

  u.serialize = (options) ->
    data = options.data
    if options.contentType is 'application/json'
      data = JSON.stringify(options.data)
    data

  u