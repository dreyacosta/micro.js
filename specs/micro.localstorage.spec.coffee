"use strict"

describe "LocalstorageDB", ->
  user1 =
    username: "dreyacosta"
    site: "dreyacosta.com"
    twitter: "@dreyacosta"

  user2 =
    username: "mike"
    site: "mike.com"
    twitter: "@m1k3"

  it "should not load a collection if not exist", ->
    response = u.db.load "movies"
    expect(response).toEqual false

  it "should save an item to a collection", ->
    response = u.db.save "users", user1
    expect(response.username).toEqual "dreyacosta"
    response = u.db.save "users", user2
    expect(response.username).toEqual "mike"

  it "should return a pure object on save", ->
    response = u.db.save "users",
      username: "trey"
      site: "treyr.com"
      twitter: "@trey"
    expect(response.username).toEqual "trey"
    response.username = "Dave"
    response = u.db.findOne "users", twitter: "@trey"
    expect(response.username).toEqual "trey"

  it "should load data from a collection", ->
    response = u.db.load "users"
    expect(response).toEqual true
    expect(u.db.data["users"].length).toEqual 3

  it "should findOne item of a collection", ->
    response = u.db.findOne "users", username: "mike"
    expect(response.length).toBeUndefined()
    expect(response.twitter).toEqual "@m1k3"

  it "should return a pure object when findOne", ->
    response = u.db.findOne "users", username: "mike"
    expect(response.username).toEqual "mike"
    response.username = "dave"
    response = u.db.findOne "users", username: "mike"
    expect(response.username).toEqual "mike"

  it "should return an empty object if no match on find one", ->
    item = u.db.findOne "users", username: "paul"
    expect(typeof item).toEqual "object"
    expect(Object.keys(item).length).toEqual 0

  it "should return an empty object if no attributes pass on find one", ->
    item = u.db.findOne "users"
    expect(typeof item).toEqual "object"
    expect(Object.keys(item).length).toEqual 0

  it "should find items in a collection", ->
    response = u.db.find "users", site: "dreyacosta.com"
    expect(response.length).toEqual 1
    expect(response[0].twitter).toEqual "@dreyacosta"

  it "should return a pure array when find all", ->
    response = u.db.find "users", username: "dreyacosta"
    expect(response.length).toEqual 1
    expect(response[0].username).toEqual "dreyacosta"
    response[0].username = "dave"
    response = u.db.find "users", username: "dreyacosta"
    expect(response.length).toEqual 1
    expect(response[0].username).toEqual "dreyacosta"

  it "should return an empty array if no match on find all", ->
    items = u.db.find "users", name: "paul"
    expect(items.length).toEqual 0

  it "should update item of a collection", ->
    data = u.db.findOne "users", username: "mike"
    response = u.db.update "users", data.uuid, color: "blue"
    expect(response.username).toEqual "mike"
    expect(response.color).toEqual "blue"

  it "should return a pure object when update", ->
    data = u.db.findOne "users", username: "mike"
    response = u.db.update "users", data.uuid, color: "blue"
    expect(response.username).toEqual "mike"
    expect(response.color).toEqual "blue"
    response.username = "cat"
    response.color = "brown"
    data = u.db.findOne "users", username: "mike"
    expect(data.username).toEqual "mike"
    expect(data.color).toEqual "blue"

  it "should remove an item of a collection", ->
    data = u.db.findOne "users", username: "mike"
    response = u.db.remove "users", data.uuid
    expect(response).toEqual true

  it "should not remove an item if not exist", ->
    data = u.db.findOne "users", username: "monster"
    response = u.db.remove "users", data.uuid
    expect(response).toEqual false