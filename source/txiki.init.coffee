((root) ->
  'use strict'

  forEach = Array::forEach
  push    = Array::push
  slice   = Array::slice

  TK = window.TK = (selector) ->
    if !(this instanceof TK)
      return new TK(selector)

    if !selector
      return this

    if selector instanceof TK
      return selector

    if typeof selector is 'string'
      return push.apply this, slice.call(document.querySelectorAll(selector))

    if typeof selector is 'function'
      TK(document).ready selector

  TK:: =
    length: 0

    each: (callback) ->
      forEach.call this, (el, idx) ->
        callback.call(el, idx)

    ready: (callback) ->
      if document.readyState is 'complete'
        callback TK

      document.addEventListener 'DOMContentLoaded', ->
        callback TK

    text: (value) ->
      this.each ->
        this.textContent = value

  return TK
) this