var run = require('../build/run');

var commands = [
  'elm package install --yes',
  'elm make Index.elm --output obj/index.js --warn',
  'uglifyjs obj/index.js --compress warnings=false --mangle --stats --output index.js'
];

run(__dirname, commands);
