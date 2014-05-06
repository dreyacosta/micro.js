'use strict'

el = document.write '<div id="fixture">Fixture</div>'

describe "DOM manipulation methods", ->

  it "should get fixture div textContent", ->
    div = u('#fixture')
    expect(do div.text).toEqual 'Fixture'

  it "should get fixture div innerHTML", ->
    div = u('#fixture')
    expect(do div.html).toEqual 'Fixture'

  it "should modify fixture div content", ->
    div = u('#fixture').html 'Hello World'
    expect(do div.html).toEqual 'Hello World'

  it "should append div to fixture div", ->
    newEl = document.createElement 'div'
    newEl.innerHTML = 'New append element div'
    newEl.setAttribute 'id', 'append'
    u('#fixture').append newEl
    expect(do u('#fixture').find('#append').html).toEqual 'New append element div'

  it "should prepend div to fixture div", ->
    newEl = document.createElement 'div'
    newEl.innerHTML = 'New prepend element div'
    newEl.setAttribute 'id', 'prepend'
    u('#fixture').prepend newEl
    expect(do u('#fixture').find('#prepend').html).toEqual 'New prepend element div'