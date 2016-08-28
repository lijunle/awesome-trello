var run = require('../build/run');
var patch = require('../build/patch');

var commands = [
  'elm package install --yes',
  'elm make Index.elm --output dist/index.debug.js --warn',
  'uglifyjs dist/index.debug.js --compress warnings=false --mangle --stats --output ./dist/index.js'
];

run(__dirname, commands);
patch(__dirname, './dist/index.js', '{TRELLO_KEY}', process.env.TRELLO_KEY);
patch(__dirname, './dist/index.js', '{TRELLO_APP_NAME}', process.env.TRELLO_APP_NAME);
