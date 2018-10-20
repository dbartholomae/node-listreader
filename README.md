# node-listreader@1.0.1
## !!! This package is no longer maintained !!!
The **node-listreader** is a node module to read all lines via a buffer from a file into an array:

```coffeescript
new ListReader().readList "data/list.txt", (err, arr) ->
  console.log el for el in arr
```

## API

The module can be required via node's require, or as an AMD module via requirejs.
You can either set the path at construction via `new ListReader(path)` or when reading the file via `listReader.readList(path)`.
You can either wait for a callback as in the example above or receive a promise (powered by [when][when]):
```coffeescript
promise = new ListReader().readList "data/list.txt"
promise.done (arr) ->
  console.log el for el in arr
```
There is a codo created documentation in the doc folder with more details.

[when]: https://github.com/cujojs/when
