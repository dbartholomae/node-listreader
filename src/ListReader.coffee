((factory) ->
  # Use define if amd compatible define function is defined
  if typeof define is 'function' && define.amd
    define ['fs', 'split', 'when'], factory
  # Use node require if not
  else
    fs = require 'fs'
    split = require 'split'
    When = require 'when'
    module.exports = factory fs, split, When
) (fs, split, When) ->

  # ListReader reads in a text file and gives an array of its lines
  # @example
  #   new ListReader().readList "data/list.txt", (err, arr) ->
  #     console.log el for el in arr
  class ListReader
    # Creates a new ListReader. You can preset the file path as an argument
    # to the constructor or give it when calling readList
    # The path is relative to the working directory where Node is run.
    #
    # @param [String] (path) The path to the file that is to be converted
    constructor: (@path) ->

    # Reads in a list from a text file and returns the array created. When the file is read or an error occurs,
    # the callback is called. If no callback is given, a promise for the array is returned.
    # The path is relative to the working directory where Node is run.
    #
    # Please note that the reader discards the first character it encounters as it assumes it to be a Byte Order Mark.
    #
    # @throw No path set
    # @overload readList(path, callback)
    #   @param [String] (path) The file path of the file. If not set, the path from the constructor will be used
    #   @param [function] callback The callback (err, result) with err being any errors from fs.createReadStream and result the Array of lines from the file
    # @overload readList(path)
    #   @param [String] (path) The file path of the file. If not set, the path from the constructor will be used
    #   @return [Promise] Promise for the array with the file contents
    readList: (path, callback) ->
      if typeof path == 'function'
        callback = path
        path = null

      path ?= @path
      throw new Error "No path set" unless path?

      result = new Array()
      firstByte = true

      stream = fs.createReadStream path,
        encoding: 'utf8'
      .pipe split()
      .on 'data', (line) ->
        if firstByte
          line = line.slice(1) # Remove byte-order mark
          firstByte = false
        result.push line

      if callback
        stream.on 'error', callback
        .on 'end', (-> callback null, result)
      else
        return When.promise (resolve, reject, notify) ->
          stream.on 'error', reject
          .on 'end', -> resolve result

  return ListReader