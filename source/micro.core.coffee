'use strict'

forEach = Array::forEach
push    = Array::push
slice   = Array::slice

u = (selector) ->
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

u.VERSION = '0.0.1'

if typeof module isnt 'undefined'
  if module.exports
    exports = module.exports = u
  exports.u = u

window.u = u if typeof window isnt 'undefined'

module.exports = u