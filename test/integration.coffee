through       = require 'through2'
config        = require 'config-object'
Stream        = require '..'

config.load 'config.cson', required: yes

module.exports = ->
  it 'reads tweets', (done) ->
    @timeout 10000
    stream = Stream config
    stream
      .tap (tweet) -> console.log tweet.created_at, tweet.text
      .done -> do done
