var path = require('path');
var chalk = require('chalk');
var extend = require('object-assign');
var execSync = require('child_process').execSync;

var bin = path.resolve(__dirname, '../node_modules/.bin');
var envPath = bin + path.delimiter + process.env.PATH;
var envBag = process.platform === 'win32' ? { Path: envPath } : { PATH: envPath };
var env = extend({}, process.env, envBag);

module.exports = function run(cwd, command, options) {
  options = options || {};

  console.log(
    chalk.dim('>'),
    chalk.bold.white(options.showAs || command)
  );

  execSync(command, {
    cwd: cwd,
    env: env,
    stdio: ['inherit', 'inherit', 'inherit'],
  });
};
