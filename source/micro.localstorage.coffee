"use strict"

localDB =
  data: {}

  _checkCollection: (collection) ->
    @data[collection] = if @data[collection] then @data[collection] else []

  get: (collection) ->
    if localStorage.getItem collection
      @data[collection] = JSON.parse localStorage.getItem(collection)

  clear: (collection) ->
    delete @data[collection]
    localStorage.removeItem collection

  write: (collection) ->
    localStorage.setItem collection, JSON.stringify @data[collection]

  save: (collection, data) ->
    items = @_checkCollection collection
    items.push data
    @write collection
    data

  findOne: (collection, attrs) ->
    _filterOne @data[collection], _matches attrs if @data[collection]

  find: (collection, attrs) ->
    _filter @data[collection], _matches attrs if @data[collection]

  update: (collection, key, value, attrs) ->
    items = @_checkCollection collection
    items.push attrs if items.length is 0
    data = item for item in items when item[key] is value
    data[key] = val for key, val of attrs
    @write collection
    data

  remove: (collection, key, value) ->
    items = @_checkCollection collection
    index = items.indexOf item for item in items when item[key] is value
    items.splice index, 1 if index > -1
    @write collection

# -- Private methods -----------------------------------------------------------
_filter = (obj, predicate) ->
  result = []
  result.push(item) for item in obj when predicate item
  result

_filterOne = (obj, predicate) ->
  return item for item in obj when predicate item
  false

_matches = (attrs) ->
  (obj) ->
    return false for key, val of attrs when attrs[key] isnt obj[key]
    true

module.exports = localDB