gulp          = require 'gulp'
del           = require 'del'

{
  src
  dest
  parallel
  series
  task
  watch
} = gulp

module.exports = ({ source }) ->
  source ?= 'build/'

  task 'clean', ->
    del source
