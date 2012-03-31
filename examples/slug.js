var hem  = new (require('hem'));
var argv = process.argv.slice(2);

hem.compilers.less = require('hem-less').compiler;

hem.exec(argv[0]);
