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