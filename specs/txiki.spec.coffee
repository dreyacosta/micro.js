describe "txiki unit test", ->


  it "should extend an object", ->
    hello =
      init: ->
        return 'Hello'

    world =
      name: ->
        return 'Tierra'

    TK.extend(hello, world)

    expect(hello.name()).toEqual('Tierra')


  it "should return a new instance", ->
    expect(TK('selector') instanceof TK).toBe(true)