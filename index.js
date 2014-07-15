var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var fs = require('fs')
	, path = require('path')
	, twit = require('twit')
	, request = require('request');


var config1 = require('twit/config1')

var logwriter = require('./lib/logwriter')

var Twit = new twit(config1);
var username = null;

var LogWriter = new logwriter('ghostLog.txt', function(exists) { });

var stream = Twit.stream('statuses/filter', { track: '#ghostselfie' });

// Testing webpage
app.get('/ghostselfie', function(req, res){
	res.sendfile('index.html');
	/*
	if(username !== null){
		res.send(username);
	} else {
		res.send('nothing yet')
	}
	*/
});


// io connections
io.on('connection', function(socket){
	console.log('a user connected');

	// sends out if user is tweeting
	socket.on('get user', function(msg){
		if(username !== null){
			msg = username;
		} else {
			msg = "null";
		}
		console.log('sending user: ' + username);
	   io.emit('sending user', msg);
	});

	// sends file that is ready and clears users
	socket.on('file ready', function(msg){
		
		console.log('ready file: ' + msg);
		//upload file here
		username = null;
	});
	
	// disconnect from server
	socket.on('disconnect', function(){
		console.log('user disconnected');
	});
});

http.listen(3000, function(){
	console.log('listening on *:3000');
});

// twitter listning stream
stream.on('tweet', function (tweet) {
  //console.log(tweet)
  //console.log(tweet.user.name)
  username = tweet.user.name;
  LogWriter.writeUserAndTime(tweet.user.name, tweet.user.screen_name, tweet.created_at);

});
