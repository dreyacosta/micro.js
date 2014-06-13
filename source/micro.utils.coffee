'use strict'

utils =
  subscribers: {}

  subscribe: (topic, func) ->
    if !@subscribers[topic] then @subscribers[topic] = []
    if @subscribers[topic].indexOf(func) is -1 then @subscribers[topic].push func
    return

  unsubscribe: (topic, func) ->
    listeners = @subscribers[topic]
    return if !listeners
    index = listeners.indexOf(func)
    listeners.splice(index, 1) if index > -1
    return

  publish: (topic, eventObj) ->
    return false if !@subscribers[topic]
    if !eventObj.type then eventObj.type = topic
    listeners = @subscribers[topic]
    listener(eventObj) for listener in listeners

  extend: (obj) ->
    args = Array::slice.call(arguments, 1)
    args.forEach (source) ->
      obj[method] = source[method] for method of source
    obj

module.exports = utils