var path = require('path');
var extend = require('object-assign');
var execSync = require('child_process').execSync;

var bin = path.resolve(__dirname, '../node_modules/.bin');
var envPath = bin + path.delimiter + process.env.PATH;
var envBag = process.platform === 'win32' ? { Path: envPath } : { PATH: envPath };
var env = extend({}, process.env, envBag);

module.exports = function run(cwd, commands) {
  commands.forEach(function (command) {
    console.log('> ' + command);
    execSync(command, {
      cwd: cwd,
      env: env,
      stdio: ['inherit', 'inherit', 'inherit'],
    });
  });
};
