class Report
  constructor: (@tagAttrs) ->

  log: ->
    Object
      .keys(@tagAttrs)
      .map((key) =>
        mapKey = @tagAttrs[key].qty + "-" + @tagAttrs[key].name
        (attrs = {})[mapKey] = @tagAttrs[key]
      )
      .sort ((a, b) ->
        if a.qty > b.qty then -1 else 1)
      .map (key) ->
        text = key.name + ' ' + key.qty
        console.log text

module.exports = Report


