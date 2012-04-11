var stitch  = require('stitch');
var express = require('express');

var package = stitch.createPackage({
  paths: [__dirname + '/lib']
});

var app = express.createServer();
app.use(express.static(__dirname + '/public'));
app.get('/application.js', package.createServer());
app.set('view engine', 'jade')
app.get('/', function(req, res) { res.render('index', {layout: false}) });
app.listen(3000);
