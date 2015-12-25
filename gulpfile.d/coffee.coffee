gulp          = require 'gulp'
coffee        = require 'gulp-coffee'
sourcemaps    = require 'gulp-sourcemaps'
cached        = require 'gulp-cached'

{
  src
  dest
  parallel
  series
  task
  watch
} = gulp

module.exports = ({ source, destination }) ->
  source      ?= 'src/**/*.coffee'
  destination ?= 'build/'

  task 'coffee', ->
    gulp
      .src  source
      .pipe cached 'coffee'
      .pipe sourcemaps.init()
      .pipe coffee()
      .pipe sourcemaps.write '.'
      .pipe dest destination
