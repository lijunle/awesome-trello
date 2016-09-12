var path = require('path');
var chalk = require('chalk');
var rimraf = require('rimraf');

module.exports = function(cwd, folder) {
  var folderPath = path.resolve(cwd, folder);

  console.log(
    chalk.dim('>'),
    chalk.bold.white('Remove folder'),
    chalk.bold.yellow(folderPath)
  );

  rimraf.sync(folderPath);
};
