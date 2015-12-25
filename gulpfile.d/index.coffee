# Setup tasks. Takes an object.

module.exports = (tasks) ->
  for task, options of tasks
    constructor = require "./#{task}"
    constructor options
