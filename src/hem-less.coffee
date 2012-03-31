{dirname} = require('path')
fs        = require('fs')
less      = require('./less-sync')
util      = require('util')

# less compiler
compiler = (path) ->
  content = fs.readFileSync path, 'utf8'
  output  = ''

  less.render content, paths: [dirname(path)], (e, css) =>
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
