do (u) ->
  'use strict'

  u.subscribers = {}

  u.extend = (obj) ->
    args = Array::slice.call(arguments, 1)
    args.forEach (source) ->
      obj[method] = source[method] for method of source
    return obj

  u.subscribe = (topic, func) ->
    if !u.subscribers[topic] then u.subscribers[topic] = []
    if u.subscribers[topic].indexOf(func) is -1 then u.subscribers[topic].push func
    return

  u.unsubscribe = (topic, func) ->
    listeners = u.subscribers[topic]
    return if !listeners
    index = listeners.indexOf(func)
    listeners.splice(index, 1) if index > -1
    return

  u.publish = (topic, eventObj) ->
    return false if !u.subscribers[topic]
    if !eventObj.type then eventObj.type = topic
    listeners = u.subscribers[topic]
    listener(eventObj) for listener in listeners

  ###
  Usage:
    u.ajax({
      type: 'GET',
      url: '/my/url',
      success: func(resp) {

      },
      error: func(resp) {

      }
    });
  ###
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

    options = u.extend(ajaxSettings, options)

    options.data = u.serialize(options)

    req = new XMLHttpRequest()

    req.open options.type, options.url, options.async

    req.onload = ->
      res = req.responseText
      if req.status >= 200 and req.status < 400
        res = JSON.parse(req.responseText) if options.dataType is 'application/json'
      options.success(res)

    req.onerror = ->
      options.error 'error'

    _xhrHeaders req, options

    req.send(options.data)
    req

  u.serialize = (options) ->
    return JSON.stringify(options.data) if options.contentType is 'application/json'
    return options.data

  _xhrHeaders = (xhr, options) ->
    options.headers['Content-Type'] = options.contentType if options.contentType
    options.headers['Accept'] = options.dataType if options.dataType
    for header of options.headers
      xhr.setRequestHeader header, options.headers[header]
    return