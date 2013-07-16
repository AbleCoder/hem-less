# This was heavily influenced by this less.js pull request:
# https://github.com/fson/less.js/commit/e21ddb74de6017cbce7a9cf1f3406697b98774ec
{dirname, join} = require('path')
fs              = require('fs')
less            = require('less')

# monkey patch LESS to read files synchronously
less.Parser.importer = (file, currentFileInfo, callback, env) ->
  paths = env.paths

  parseFile = (e, data) ->
    return callback(e)  if e

    new (less.Parser)(
      paths: [ dirname(pathname) ].concat(paths)
      filename: pathname
      syncImport: env.syncImport
    ).parse data, (e, root) ->
      callback e, root, data

  env.syncImport = true
  pathname = null
  data = ""
  paths.unshift "."

  for path in paths
    try
      pathname = join(path, file)
      fs.statSync pathname
      break
    catch e
      pathname = null

  unless pathname
    if typeof (env.errback) is "function"
      env.errback file, paths, callback
    else
      callback
        type: "File"
        message: "'" + file + "' wasn't found.\n"
    return

  try
    data = fs.readFileSync(pathname, "utf-8")
    parseFile null, data
  catch e
    parseFile e

module.exports = less
