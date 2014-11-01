"use strict"

localDB =
  data: {}

  _checkCollection: (collection) ->
    return if @data[collection]
    return @data[collection] if @load collection
    @data[collection] = []

  load: (collection) ->
    if localStorage.getItem collection
      @data[collection] = JSON.parse localStorage.getItem(collection)
      return true
    false

  clear: (collection) ->
    @data[collection] = null
    localStorage.removeItem collection

  write: (collection) ->
    localStorage.setItem collection, JSON.stringify @data[collection]

  save: (collection, data) ->
    @_checkCollection collection
    data.uuid = do _uuid
    @data[collection].push data
    @write collection
    _extend {}, data

  findOne: (collection, attrs) ->
    @_checkCollection collection
    return {} if !attrs
    _filterOne @data[collection], _matches attrs

  find: (collection, attrs) ->
    @_checkCollection collection
    return @data[collection] if !attrs
    _filter @data[collection], _matches attrs

  update: (collection, id, attrs) ->
    @_checkCollection collection
    data = item for item in @data[collection] when item.uuid is id
    unless data
      data = {}
      data.uuid = do _uuid
      @data[collection].push data
    data[key] = val for key, val of attrs if data
    @write collection
    _extend {}, data

  remove: (collection, id) ->
    @_checkCollection collection
    index = @data[collection].indexOf(item) for item in @data[collection] when item.uuid is id
    return false if not index and index isnt 0
    @data[collection].splice index, 1 if index > -1
    @write collection
    true

# -- Private methods -----------------------------------------------------------
_uuid = ->
  date = new Date().getTime()
  uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = (date + Math.random() * 16) % 16 | 0
    date = Math.floor date/16
    v = if c is 'x' then r else r & 7 | 8
    v.toString 16

_filter = (obj, predicate) ->
  result = []
  result.push _extend({}, item) for item in obj when predicate item
  result

_filterOne = (obj, predicate) ->
  result = {}
  return _extend result, item for item in obj when predicate item
  result

_matches = (attrs) ->
  (obj) ->
    return false for key, val of attrs when attrs[key] isnt obj[key]
    true

_extend = (obj, args...) ->
  args.forEach (source) ->
    obj[method] = source[method] for method of source when hasOwnProperty.call source, method
  obj

module.exports = localDB