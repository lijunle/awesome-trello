var path = require('path');
var watch = require('watch');
var run = require('../build/run');

function isPackage(file) {
  return path.basename(file) === 'elm-package.json';
}

function isElm(file) {
  return path.extname(file) === '.elm';
}

function runWatch(file) {
  try {
    if (isPackage(file)) {
      run(__dirname, ['elm package install --yes']);
    } else if (isElm(file)) {
      console.log('Change file ' + file);
      run(__dirname, ['elm make --warn Index.elm --output index.js']);
    } else {
      // No-op
    }
  } catch (e) {
    // Skip any error in watch mode.
  }
}

watch.watchTree(
  __dirname,
  {
    ignoreNotPermitted: true,
    ignoreUnreadableDir: true,
    ignoreDirectoryPattern: /(obj|bin)/,
    filter: function filter(file) {
      return isPackage(file) || isElm(file);
    }
  },
  function (file, curr, prev) {
    if (typeof file == "object" && prev === null && curr === null) {
      // Finished walking the tree
      runWatch('elm-package.json');
      runWatch('Index.elm');

      console.log('Start monitor the directory ' + __dirname);
      Object.keys(file).forEach(function finish(filename) {
        console.log('- ' + filename);
      });
    } else if (prev === null) {
      // File is new
      runWatch(file);
    } else if (curr.nlink === 0) {
      // File is removed
      // No-op
    } else {
      // File is changed
      runWatch(file);
    }
  }
);
