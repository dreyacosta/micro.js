((TK) ->
  TK.topics = {}

  TK.extend = (obj) ->
    args = Array::slice.call(arguments, 1)

    args.forEach (source) ->
      obj[method] = source[method] for method of source

    return obj

  TK.subscribe = (topic, func) ->
    if !TK.topics[topic] then TK.topics[topic] = []

    if TK.topics[topic].indexOf(func) is -1 then TK.topics[topic].push func

    return this

  TK.unsubscribe = (topic, func) ->
    listeners = TK.topics[topic]

    return if !listeners

    index = listeners.indexOf(func)

    listeners.splice(index, 1) if index > -1

  TK.trigger = (topic, eventObj) ->
    return false if !TK.topics[topic]

    if !eventObj.type then eventObj.type = topic

    listeners = TK.topics[topic]

    listener(eventObj) for listener in listeners
) TK