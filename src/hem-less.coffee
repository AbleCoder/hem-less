path      = require('path')
{dirname} = path
fs        = require('fs')
less      = require('./less-sync')
util      = require('util')
options   = undefined

setOptions = (o) ->
  options = o

# less compiler
compiler = (filepath) ->
  content = fs.readFileSync filepath, 'utf8'
  output  = ''
  options = options or {}
  options.paths = [dirname(filepath)]

  less.render content, options, (e, css) =>
    throw e if e
    output = css

  output

# register .less file ext module loader
require.extensions['.less'] = (module, filename) ->
  source = ''
  try
    source = compiler(filename)
  catch e
    # print less error to console
    util.error """
    LESS ERROR:
      file: #{e.filename ? filename}
      message: #{e.message}
    """

  module._compile("module.exports = #{JSON.stringify(source)}", filename)

module.exports =
  compiler: compiler
  setOptions: setOptions
