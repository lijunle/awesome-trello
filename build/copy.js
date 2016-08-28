var fs = require('fs');
var path = require('path');
var mkdirp = require('mkdirp');

function copyFile(from, to) {
  console.log('Copy file ' + from + ' to ' + to);
  mkdirp.sync(path.dirname(to));
  fs.createReadStream(from).pipe(fs.createWriteStream(to));
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
