var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var fs = require('fs')
	, path = require('path')
	, twit = require('twit')
	, request = require('request');

var username = null;

var config1 = require('twit/config1')

var logwriter = require('./lib/logwriter')

var Twit = new twit(config1);
var LogWriter = new logwriter('ghostLog.txt', function(exists) { });

var stream = Twit.stream('statuses/filter', { track: '#ghostselfie' });

//app.use(express.bodyParser());


// twitter listning stream
stream.on('tweet', function (tweet) {
 	//console.log(tweet)
	console.log("user detected: " + tweet.user.name);
	if(username === null){
		username = tweet.user.name;
	}
	LogWriter.writeUserAndTime(tweet.user.name, tweet.user.screen_name, tweet.created_at);

});


// testing webpage
app.get('/ghostselfie', function(req, res){
	//res.sendfile('index.html');
	res.send('send stuff');
});


app.post('/location', function(req, res) {
    console.log('headers: ' + JSON.stringify(req.headers));
    console.log('user-agent: ' + req.headers['user-agent']);
    //LogWriter.writeToLog();			
    res.send('FUCK OFF DICK WEED ' + req );

});

// create web server
http.listen(3000, function(){
	console.log('listening on *:3000');
});





