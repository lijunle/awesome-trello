var path = require('path');
var run = require('../build/run');
var copy = require('../build/copy');

copy(__dirname, './index.html', './deploy/index.html');
copy(__dirname, './favicon.ico', './deploy/favicon.ico');
copy(__dirname, './dist/index.js', './deploy/dist/index.js');

var deployFolder = path.resolve(__dirname, './deploy');
run(deployFolder, 'git init');
run(deployFolder, 'git config user.name "Travis CI Build"');
run(deployFolder, 'git config user.email "build@travis-ci.org"');
run(deployFolder, 'git add . --all');
run(deployFolder, 'git commit --message "Deploy to Github Pages."');

var user = process.env.GH_USER;
var token = process.env.GH_TOKEN;
var repo = process.env.GH_REPO;
var url = 'https://' + user + ':' + token + '@' + repo;
run(deployFolder, 'git remote add origin ' + url, { showAs: 'git remote add origin (...)' });
run(deployFolder, 'git push --force --quiet origin master:gh-pages');
