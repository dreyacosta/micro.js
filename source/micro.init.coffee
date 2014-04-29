u = do ->
  'use strict'

  forEach = Array::forEach
  push    = Array::push
  slice   = Array::slice

  u = window.u = (selector) ->
    if !(this instanceof u)
      return new u(selector)

    if !selector
      return this

    if selector instanceof u
      return selector

    if typeof selector is 'string'
      return push.apply this, slice.call(document.querySelectorAll(selector))

    if typeof selector is 'function'
      u(document).ready selector

  u:: =
    length: 0

    each: (callback) ->
      forEach.call this, (el, idx) ->
        callback.call el, idx
      return this

    ready: (callback) ->
      if document.readyState is 'complete'
        callback u

      document.addEventListener 'DOMContentLoaded', ->
        callback u

    text: (value) ->
      this.each ->
        this.textContent = value

    html: (value) ->
      this.each ->
        this.innerHTML = value

    append: (el) ->
      this.each ->
        this.appendChild el

    prepend: (el) ->
      this.each ->
        this.insertBefore el, this.firstChild

    on: (type, func) ->
      this.each ->
        this.addEventListener type, func

    off: (type, func) ->
      this.each ->
        this.removeEventListener type, func

   u

@u = u