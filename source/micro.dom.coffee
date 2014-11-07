'use strict'

forEach = Array::forEach
push    = Array::push
slice   = Array::slice

manipulationsMethods =
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
    return this[0].textContent if value is undefined
    this.each ->
      this.textContent = value

  find: (selector) ->
    results = new u()
    this.each ->
      push.apply results, slice.call(this.querySelectorAll selector)
    return results

  html: (value) ->
    return this[0].innerHTML if value is undefined
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

module.exports = manipulationsMethods