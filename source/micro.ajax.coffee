do (u) ->
  'use strict'

  u.ajax = (options) ->
    ajaxSettings =
      type: 'GET'
      async: true
      success: (res) ->
      error: (res) ->
      contentType : 'application/json'
      headers: {}
      crossDomain: false
      timeout: 0

    options = u.extend ajaxSettings, options

    options.data = u.serialize(options)

    req = new XMLHttpRequest()

    req.open options.type, options.url, options.async

    req.onload = ->
      res = req.responseText
      if req.status >= 200 and req.status < 400
        res = JSON.parse(req.responseText) if options.contentType is 'application/json'
      options.success(res)

    req.onerror = ->
      options.error 'error'

    _xhrHeaders req, options

    req.send options.data
    req

  u.serialize = (options) ->
    return JSON.stringify(options.data) if options.contentType is 'application/json'
    return options.data

  _xhrHeaders = (xhr, options) ->
    options.headers['Content-Type'] = options.contentType if options.contentType
    options.headers['Accept'] = options.contentType if options.contentType
    for header of options.headers
      xhr.setRequestHeader header, options.headers[header]
    return