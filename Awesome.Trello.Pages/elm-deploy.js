var copy = require('../build/copy');

copy(__dirname, './index.html', './deploy/index.html');
copy(__dirname, './dist/index.js', './deploy/dist/index.js');
