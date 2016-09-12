var fs = require('fs');
var path = require('path');
var chalk = require('chalk');
var mkdirp = require('mkdirp');

function copyFile(from, to) {
  const fromDirName = path.dirname(from);
  const fromBaseName = path.basename(from);

  console.log(
    chalk.dim('>'),
    chalk.bold.white('Copy file'),
    chalk.yellow(fromDirName + path.sep) + chalk.bold.yellow(fromBaseName)
  );

  console.log(
    chalk.dim(' '),
    chalk.white('to'),
    chalk.white(to)
  );

  mkdirp.sync(path.dirname(to));
  fs.writeFileSync(to, fs.readFileSync(from));
}

function copyFolder(from, to) {
  mkdirp.sync(to);
  fs.readdirSync(from).forEach(x => copy(path.resolve(from, x), path.resolve(to, x)));
}

function copy(from, to) {
  var stat = fs.statSync(from);
  if (stat.isFile()) {
    copyFile(from, to);
  } else if (stat.isDirectory()) {
    copyFolder(from, to);
  } else {
    // no-op
  }
}

module.exports = function(cwd, from, to) {
  var fromPath = path.resolve(cwd, from);
  var toPath = path.resolve(cwd, to);
  copy(fromPath, toPath);
};
