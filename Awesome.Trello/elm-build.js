var chalk = require('chalk');
var run = require('../build/run');
var patch = require('../build/patch');
var remove = require('../build/remove');

remove(__dirname, './elm-stuff/build-artifacts/0.17.1/lijunle');

run(__dirname, 'elm package install --yes');
run(__dirname, 'elm make Index.elm --output dist/index.debug.js --warn');
run(__dirname, 'uglifyjs dist/index.debug.js --compress warnings=false --mangle --stats --output ./dist/index.js');

patch(__dirname, './dist/index.js', '{TRELLO_KEY}', process.env.TRELLO_KEY);
patch(__dirname, './dist/index.js', '{TRELLO_APP_NAME}', process.env.TRELLO_APP_NAME);

console.log(chalk.bold.bgGreen('[[[ Build succeed ]]]'));
