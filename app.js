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


// API 

// twitter listning stream for Hash tag 
stream.on('tweet', function (tweet) {
	console.log("user detected: " + tweet.user.screen_name);
	if(username === null){
		username = tweet.user.screen_name;
	}
	LogWriter.writeUserAndTime(tweet.user.name, tweet.user.screen_name, tweet.created_at);

});


// REST 

// gets username if some one tweetet
app.get('/ghostselfie', function(req, res){
	//res.sendfile('index.html');
	if(username === null){
		res.send(username);
	} else {
		res.send("null");
	}

});

// posts image of selife sent in user-agent
app.post('/ghostselfie', function(req, res) {
    console.log('user-agent File: ' + req.headers['user-agent']);
    var gifUploadFile = req.headers['user-agent'];
    Twit.postMediaRequestFilePath(request, '@' + username, gifUploadFile, function(err, data, response) {
  		if (err) {
    		console.log(err);
  		}
  		username = null;
  		console.log(response);
	});		
    


});

// create web server
http.listen(3000, function(){
	console.log('listening on *:3000');
});





