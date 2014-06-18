'use strict'

describe "LocalstorageDB", ->
  mockData =
    username: 'dreyacosta'
    site: 'dreyacosta.com'
    twitter: '@dreyacosta'

  mockData2 =
    username: 'bird'
    site: 'twitter.com'
    twitter: '@bird'

  it "should save an item to a collection", ->
    response = u.db.save 'jasmineDB', mockData
    expect(response.username).toEqual 'dreyacosta'

    response = u.db.save 'jasmineDB', mockData2
    expect(response.username).toEqual 'bird'

  it "should get data from a collection", ->
    response = u.db.get 'jasmineDB'
    expect(response.length).toEqual 2

  it "should findOne item of a collection", ->
    response = u.db.findOne 'jasmineDB', username: 'bird'
    expect(response.length).toBeUndefined()
    expect(response.twitter).toEqual '@bird'

  it "should find items in a collection", ->
    response = u.db.find 'jasmineDB', site: 'dreyacosta.com'
    expect(response.length).toEqual 1
    expect(response[0].twitter).toEqual '@dreyacosta'