chai = require 'chai'
chai.use require 'chai-as-promised'
expect = chai.expect

pathLib = require 'path'

path = "test/data/list.txt"
expectedList = ("entry" + i for i in [1..3])

ListReader = require '../lib/ListReader'

describe "A ListReader", ->

  it "can be required via requirejs", (done) ->
    expect(
      require('requirejs') [pathLib.join(__dirname, '..', 'lib/ListReader.js')], (ListReaderLoaded) ->
        expect(ListReaderLoaded).to.exist
        done()
    ).to.not.throw

  it "throws when no path is set", ->
    listReader = new ListReader()
    expect(-> listReader.readList()).to.throw "No path set"

  describe "with a path set at construction", ->
    listReader = null
    beforeEach ->
      listReader = new ListReader path

    it "reads a list via callback", (done) ->
      listReader.readList (err, list) ->
        expect(list).to.deep.equal expectedList
        done()

    it "reads a list via Promise", ->
      expect(listReader.readList()).to.eventually.deep.equal expectedList

  describe "with a path given in the readList call", ->
    listReader = null
    beforeEach ->
      listReader = new ListReader()

    it "returns an error if the file to read does not exist", ->
      listReader.readList path + "aaa", (err, list) ->
        expect(err.code).to.equal 'ENOENT'

    it "reads a list via callback", (done) ->
      listReader.readList path, (err, list) ->
        expect(list).to.deep.equal expectedList
        done()

    it "reads a list via Promise", ->
      expect(listReader.readList(path)).to.eventually.deep.equal expectedList

