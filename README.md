[![build status](https://secure.travis-ci.org/AbleCoder/hem-less.png)](http://travis-ci.org/AbleCoder/hem-less)
# hem-less

This module adds LESS (The Dynamic Stylesheet language) support to hem (Bundler for
Node/CommonJS/Web Apps).

## Usage

1. Add `hem-less` to the dependencies in your `package.json` file in the root directory of your hem project. Here is an example:

    ```
    {
      "name": "Insanely Awesome Spine.js App w/ LESS Support",
      "version": "0.0.1",
      "dependencies": {
        "serveup": "~0.0.4",
        "hem": "~0.1.7",
        "hem-less": "~0.0.1",
        "es5-shimify": "~0.0.1",
        "json2ify": "~0.0.1",
        "jqueryify": "~0.0.1",
        "amplifyjsify": "~0.0.3",
        "bootstrap-stylus": "0.2.1",
        "spine": "~1.0.6"
      }
    }
    ```

1. Once hem-less is added to your dependencies run the following command from your project root:

    ```
    npm install .
    ```

1. Add a `slug.js` file to the root of your project with the following:
  
    ```
    var hem = new (require('hem'));
    var command = process.argv.slice(2)[0];
    var less = require('hem-less');
    var options = {
      "server": {
        compress: false
      },
      "build": {
        compress: true
      }
    };
    less.setOptions(options[command]);
    hem.compilers.less = less.compiler;
    hem.exec(command);
    ```

1. Use it! Now when you run hem in your project root it will generate CSS using the LESS compiler
   if there is a `index.less` file in your project's css dir. For example to build your app run:

    ```hem build```

    Or run the development server:

    ```hem server```
