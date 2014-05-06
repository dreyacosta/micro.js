'use strict'

describe "AJAX methods", ->

  it "should execute with the correct params", ->
    spyOn u, 'ajax'

    opts =
      type: 'GET'
      url: '/api'

    u.ajax opts
    expect(u.ajax.calls.mostRecent().args[0].type).toEqual 'GET'
    expect(u.ajax.calls.mostRecent().args[0].url).toEqual '/api'

  it "should execute the success callback", (done) ->
    spyOn(u, 'ajax').and.callFake (options) ->
      options.success 'Ajax OK'

    opts =
      type: 'GET'
      url: '/api'
      success: (res) ->
        expect(res).toEqual 'Ajax OK'
        done()

    u.ajax opts

  it "should execute the error callback", (done) ->
    spyOn(u, 'ajax').and.callFake (options) ->
      options.error 'Ajax error'

    opts =
      type: 'GET'
      url: '/api'
      error: (res) ->
        expect(res).toEqual 'Ajax error'
        done()

    u.ajax opts