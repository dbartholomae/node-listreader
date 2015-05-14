ListReader = require "../lib/ListReader"
new ListReader("test/data/list.txt").readList (err, arr) ->
  console.log el for el in arr