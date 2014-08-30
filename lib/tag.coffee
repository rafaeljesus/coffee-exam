class Tag
  constructor: (tags) ->
    @attr = {}
    (tags or []).forEach (name) =>
      @attr[name] =
        name: name
        qty: 0

  asJSON: (file, cb) ->
    try
      json = JSON.parse file
      cb null, json
    catch e
      console.error e
      cb e

  toJSON: ->
    @attr

  mapByTagName: (json) ->
    json.tags.forEach @_sum, @
    (json.children || []).map (json) =>
      (json.tags || []).forEach @_sum, @

  _sum: (name) ->
    return unless @attr[name]
    @attr[name].qty += 1

module.exports = Tag
