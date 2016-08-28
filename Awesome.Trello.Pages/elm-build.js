var run = require('../build/run');
var patch = require('../build/patch');

var commands = [
  'elm package install --yes',
  'elm make Index.elm --output temp/index.js --warn',
  'uglifyjs temp/index.js --compress warnings=false --mangle --stats --output ../Awesome.Trello/index.js'
];

run(__dirname, commands);
patch(__dirname, '../Awesome.Trello/index.js', '{TRELLO_KEY}', process.env.TRELLO_KEY);
patch(__dirname, '../Awesome.Trello/index.js', '{TRELLO_APP_NAME}', process.env.TRELLO_APP_NAME);
