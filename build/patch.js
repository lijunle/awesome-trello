var fs = require('fs');
var path = require('path');
var chalk = require('chalk');

module.exports = function(cwd, relativePath, pattern, replacement) {
  var filePath = path.resolve(cwd, relativePath);
  var fileContent = fs.readFileSync(filePath, 'utf-8');

  while (fileContent.indexOf(pattern) !== -1) {
    fileContent = fileContent.replace(pattern, replacement);
  }

  console.log(
    chalk.dim('>'),
    chalk.bold.white('Pattern'),
    chalk.bold.cyan(pattern),
    chalk.bold.white('is patched on file'),
    chalk.bold.green(relativePath)
  );

  fs.writeFileSync(filePath, fileContent, 'utf-8');
};
