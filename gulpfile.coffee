gulp          = require 'gulp'
{ fork }      = require 'child_process'
debounce      = require 'lodash.debounce'
through       = require 'through2'

# Use common tasks
tasks         = require './gulpfile.d'

tasks
  clean   : source: 'build'
  coffee  : source: 'src/**/*.coffee',  destination: 'build'
  test    : source: 'test/index.coffee'

# Destructre and DRY:
{
  parallel
  series
  task
  watch
} = gulp

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
  ], debounce (series [
    'test'
    # 'serve'
  ]), 500

task 'develop', series [
  (done) -> process.env.NODE_ENV = 'development'; do done
  'build'
  # 'serve'
  'watch'
]
