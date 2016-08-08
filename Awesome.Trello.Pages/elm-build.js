var run = require('../build/run');

var commands = [
  'elm package install --yes',
  'elm make Index.elm --output temp/index.js --warn',
  'uglifyjs temp/index.js --compress warnings=false --mangle --stats --output ../Awesome.Trello/index.js'
];

run(__dirname, commands);
