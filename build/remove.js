var path = require('path');
var rimraf = require('rimraf');

module.exports = function(cwd, folder) {
  var folderPath = path.resolve(cwd, folder);
  console.log('Remove folder', folderPath);
  rimraf.sync(folderPath);
};
