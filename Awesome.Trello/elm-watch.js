var path = require('path');
var chalk = require('chalk');
var watch = require('watch');
var browserSync = require("browser-sync").create();
var run = require('../build/run');
var patch = require('../build/patch');

var nativeFolder = path.resolve(__dirname, 'Native');
var excludeFolders = ['deploy', 'dist', 'elm-stuff'];

function isPackage(file) {
  return path.basename(file) === 'elm-package.json';
}

function isElm(file) {
  return path.extname(file) === '.elm';
}

function isFolder(folder, stats) {
  return stats.isDirectory() && excludeFolders.indexOf(path.basename(folder)) === -1;
}

function isNative(file) {
  return file.indexOf(nativeFolder) === 0;
}

function runWatch(file) {
  try {
    if (isPackage(file)) {
      run(__dirname, ['elm package install --yes']);
    } else {
      console.log(
        chalk.dim('>'),
        chalk.bold.white('Change file'),
        chalk.bold.yellow(file)
      );

      run(__dirname, 'elm make --warn Index.elm --output ./dist/index.js');
      patch(__dirname, './dist/index.js', '{TRELLO_KEY}', process.env.TRELLO_KEY);
      patch(__dirname, './dist/index.js', '{TRELLO_APP_NAME}', process.env.TRELLO_APP_NAME);

      console.log(chalk.bold.bgGreen('[[[ Build succeed ]]]'));
    }
  } catch (e) {
    // Skip any error in watch mode.
    console.log(chalk.bold.bgRed('!!! Error happens !!!'));
  }
}

watch.watchTree(
  __dirname,
  {
    ignoreNotPermitted: true,
    ignoreUnreadableDir: true,
    ignoreDirectoryPattern: /(dist|elm-stuff)/,
    filter: function filter(file, stats) {
      return (
        isPackage(file, stats)
        || isElm(file, stats)
        || isFolder(file, stats)
        || isNative(file, stats)
      );
    }
  },
  function (file, curr, prev) {
    if (typeof file == "object" && prev === null && curr === null) {
      // Finished walking the tree
      runWatch('elm-package.json');
      runWatch('Index.elm');

      console.log(
        chalk.dim('>'),
        chalk.bold.white('Monitor the directory'),
        chalk.bold.yellow(__dirname)
      );

      Object.keys(file).forEach(function finish(filename) {
        const dirname = path.dirname(filename);
        const basename = path.basename(filename);
        console.log(
          chalk.dim('-'),
          chalk.white(dirname) + path.sep + chalk.yellow(basename)
        );
      });

      browserSync.init({
        server: '.',
        files: ['dist/index.js']
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
