(function() {
  var compiler, dirname, fs, less, util;

  dirname = require('path').dirname;

  fs = require('fs');

  less = require('./less-sync');

  util = require('util');

  compiler = function(path) {
    var content, output,
      _this = this;
    content = fs.readFileSync(path, 'utf8');
    output = '';
    less.render(content, {
      paths: [dirname(path)]
    }, function(e, css) {
      if (e) throw e;
      return output = css;
    });
    return output;
  };

  require.extensions['.less'] = function(module, filename) {
    var source, _ref;
    source = '';
    try {
      source = compiler(filename);
    } catch (e) {
      util.error("LESS ERROR:\n  file: " + ((_ref = e.filename) != null ? _ref : filename) + "\n  message: " + e.message);
    }
    return module._compile("module.exports = " + (JSON.stringify(source)), filename);
  };

  module.exports = {
    compiler: compiler
  };

}).call(this);
