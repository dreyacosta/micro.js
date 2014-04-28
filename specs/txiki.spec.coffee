describe "txiki unit test", ->
  'use strict'

  it "should extend an object", ->
    hello =
      init: ->
        return 'Hello'
    world =
      name: ->
        return 'Tierra'

    u.extend(hello, world)
    expect(hello.name()).toEqual('Tierra')

  it "should subscribe to an event", ->
    hello = (e) ->
      return e
    u.subscribe 'sayHello', hello

  it "shoud publish to a subscribe event", ->
    res = u.publish 'sayHello', 'Hello David'
    expect(res[0]).toEqual('Hello David')

  it "should return a new instance", ->
    expect(u('selector') instanceof u).toBe(true)

  it "should response to a GET request", (done) ->
    spyOn(u, 'ajax').and.callFake (options) ->
      options.success 'Ajax OK'

    opts =
      type: 'GET'
      url: '/api'
      success: (res) ->
        expect(res).toEqual 'Ajax OK'
        done()

    u.ajax opts