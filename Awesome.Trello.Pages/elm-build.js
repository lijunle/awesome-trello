var run = require('../build/run');
var patch = require('../build/patch');

run(__dirname, 'elm package install --yes');
run(__dirname, 'elm make Index.elm --output dist/index.debug.js --warn');
run(__dirname, 'uglifyjs dist/index.debug.js --compress warnings=false --mangle --stats --output ./dist/index.js');

patch(__dirname, './dist/index.js', '{TRELLO_KEY}', process.env.TRELLO_KEY);
patch(__dirname, './dist/index.js', '{TRELLO_APP_NAME}', process.env.TRELLO_APP_NAME);
