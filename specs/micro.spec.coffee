'use strict'

describe "u method", ->

  it "should return a new instance", ->
    expect(u('selector') instanceof u).toBe(true)