gulp          = require 'gulp'
del           = require 'del'
coffee        = require 'gulp-coffee'
sourcemaps    = require 'gulp-sourcemaps'
cached        = require 'gulp-cached'
mocha         = require 'gulp-mocha'
{ fork }      = require 'child_process'
debounce      = require 'lodash.debounce'
through       = require 'through2'

# Destructre and DRY:
{
  src
  dest
  parallel
  series
  task
  watch
} = gulp

task 'clean', ->
  del 'build/'

task 'coffee', ->
  gulp
    .src 'src/**/*.coffee'
    .pipe cached 'coffee'
    .pipe sourcemaps.init()
    .pipe coffee()
    .pipe sourcemaps.write '.'
    .pipe dest 'build/'

task 'test', ->
  gulp
    .src 'test/index.coffee'
    .pipe mocha reporter: 'spec', require: ['source-map-support/register']

task 'build', series [
  'clean'
  'coffee'
  'test'
]

# Temporary fix for https://github.com/chaijs/chai-http/issues/40
# TODO: Help address issues with https://github.com/chaijs/chai-http/pull/41
delay = (fn, time) -> (done) -> setTimeout fn, time; do done

task 'prepublish', series [
  'build'
  delay process.exit, 200
]

server = null
task 'serve', (done) ->
  console.log '(Re)starting server...'
  do server?.kill
  server = fork './build/start'
  do done

task 'watch', ->
  watch [
    'src/**/*.coffee'
  ], series ['coffee']

  watch [
    'test/**/*'
    # Ignore sqlite or leveldb data files in test dir
    '!test/data'
    '!test/**/data'
    '!test/**/data/**/*'
  ], series ['test']

  watch [
    'build/**/*'
    'default.cson'
    'config.cson'
    'package.json'
  ], debounce (series ['test', 'serve']), 500

task 'develop', series [
  (done) -> process.env.NODE_ENV = 'development'; do done
  'build'
  'serve'
  'watch'
]
