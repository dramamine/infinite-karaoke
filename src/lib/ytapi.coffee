YouTube = require 'youtube-node'
config = require '../../scripts/youtube-api-cfg'
Q = require 'q'

youtube = new YouTube()
youtube.setKey config.api_key

YTAPI =
  lookup: (id) ->
    deferred = Q.defer()
    console.log 'lookup called', id

    youtube.getById id, (err, result) ->
      if err
        console.error err
        deferred.reject err
      unless result.items && result.items[0]
        deferred.reject result
      deferred.resolve result.items[0]

    return deferred.promise


module.exports = YTAPI
