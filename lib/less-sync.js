(function() {
  var dirname, fs, join, less, _ref;

  _ref = require('path'), dirname = _ref.dirname, join = _ref.join;

  fs = require('fs');

  less = require('less');

  less.Parser.importer = function(file, paths, callback, env) {
    var data, parseFile, path, pathname, _i, _len;
    parseFile = function(e, data) {
      if (e) return callback(e);
      return new less.Parser({
        paths: [dirname(pathname)].concat(paths),
        filename: pathname,
        syncImport: env.syncImport
      }).parse(data, function(e, root) {
        return callback(e, root, data);
      });
    };
    env.syncImport = true;
    pathname = null;
    data = "";
    paths.unshift(".");
    for (_i = 0, _len = paths.length; _i < _len; _i++) {
      path = paths[_i];
      try {
        pathname = join(path, file);
        fs.statSync(pathname);
        break;
      } catch (e) {
        pathname = null;
      }
    }
    if (!pathname) {
      if (typeof env.errback === "function") {
        env.errback(file, paths, callback);
      } else {
        callback({
          type: "File",
          message: "'" + file + "' wasn't found.\n"
        });
      }
      return;
    }
    try {
      data = fs.readFileSync(pathname, "utf-8");
      return parseFile(null, data);
    } catch (e) {
      return parseFile(e);
    }
  };

  module.exports = less;

}).call(this);
