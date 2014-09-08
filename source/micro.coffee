u            = require('./micro.core.coffee')
dom          = require('./micro.dom.coffee')
utils        = require('./micro.utils.coffee')
localstorage = require('./micro.localstorage.coffee')
ajax         = require('./micro.ajax.coffee')

utils.extend u::, dom
utils.extend u, utils, db: localstorage, ajax

window.u = u if typeof window isnt 'undefined'

module.exports = u