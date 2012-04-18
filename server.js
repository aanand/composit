var stitch  = require('stitch');
var express = require('express');
var less    = require('less');

var package = stitch.createPackage({
  paths: [__dirname + '/lib']
});

express.compiler.compilers.less.compile = function(str, fn){
  try {
    less.render(str, {paths: [__dirname + '/public']}, fn);
  } catch (err) {
    fn(err);
  }
};

var port = process.env.PORT || 3000;
var app = express.createServer();
app.use(express.compiler({ src: __dirname + '/public', enable: ['less'] }));
app.use(express.static(__dirname + '/public'));
app.get('/application.js', package.createServer());
app.set('view engine', 'jade')
app.get('/', function(req, res) { res.render('index', {layout: false}) });
app.listen(port);

console.log("Listening on port " + port);