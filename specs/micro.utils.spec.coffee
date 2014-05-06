'use strict'

describe "Utils methods", ->

  it "should extend an object", ->
    hello =
      init: ->
        return 'Hello'
    world =
      name: ->
        return 'Tierra'

    u.extend(hello, world)
    expect(hello.name()).toEqual('Tierra')

describe "Pub/Sub pattern", ->

  it "should subscribe to an event", ->
    hello = (e) ->
      return e
    u.subscribe 'sayHello', hello

  it "shoud publish to a subscribe event", ->
    res = u.publish 'sayHello', 'Hello David'
    expect(res[0]).toEqual('Hello David')