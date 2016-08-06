var path = require('path');
var extend = require('object-assign');
var execSync = require('child_process').execSync;

var bin = path.resolve(__dirname, '../node_modules/.bin');
var envPath = bin + path.delimiter + process.env.PATH;

module.exports = function run(cmd, commands) {
  commands.forEach(function (command) {
    console.log('> ' + command);
    execSync(command, {
      cwd: cmd,
      env: extend({}, process.env, { PATH: envPath }),
      stdio: ['inherit', 'inherit', 'inherit'],
    });
  });
}
