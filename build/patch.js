var path = require('path');
var fs = require('fs');

module.exports = function(cwd, relativePath, pattern, replacement) {
  var filePath = path.resolve(cwd, relativePath);
  var fileContent = fs.readFileSync(filePath, 'utf-8');

  while (fileContent.indexOf(pattern) !== -1) {
    fileContent = fileContent.replace(pattern, replacement);
  }

  fs.writeFileSync(filePath, fileContent, 'utf-8');
  console.log('Patch file is done', relativePath);
};
