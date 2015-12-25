Twitter       = require 'twitter'
Stream        = require 'highland'

module.exports = ({ auth }) -> Stream (push, next) ->
  twitter   = new Twitter auth

  # TODO: Take this from config
  endpoint  = 'statuses/user_timeline'

  get_more_tweets = (max_id) ->
    params    = Object.assign
      screen_name : 'lazurski'
      trim_user   : yes
      count       : 100
    ,
      { max_id }

    twitter.get endpoint, params, (error, tweets, res) ->
      console.dir { error }

      if not tweets?.length then return push error, Stream.nil

      for tweet in tweets
        push error, tweet

      { id } = tweet
      get_more_tweets id - 1

  do get_more_tweets
