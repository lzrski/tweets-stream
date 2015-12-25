gulp          = require 'gulp'
mocha         = require 'gulp-mocha'

{
  src
  dest
  parallel
  series
  task
  watch
} = gulp

module.exports = ({ source }) ->
  source ?= 'test/index.coffee'
  
  task 'test', ->
    gulp
      .src  source
      .pipe mocha reporter: 'spec', require: ['source-map-support/register']
