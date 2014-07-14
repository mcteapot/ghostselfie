var fs = require('fs');
var path = require('path');
var twit = require('twit')
var request = require('request');

var config1 = require('twit/config1')

var logwriter = require('./lib/logwriter')

// Inits
var Twit = new twit(config1);

var LogWriter = new logwriter('ghostLog.txt', function(exists) {


});

//console.log(config1);


//LogWriter.writeUserAndTime('mikel jordan','funkeybutt', 'Fri Jul 11 20:21:26 +0000 2014');
//LogWriter.writeUserAndTime('rank lombard','rockandroller', 'Fri Jul 11 20:21:26 +0000 2015');

//console.log("TRACKING #therecameanecho")


var stream = Twit.stream('statuses/filter', { track: '#ghostselfie' })

stream.on('tweet', function (tweet) {
  //console.log(tweet)
  //console.log(tweet.user.name)
  LogWriter.writeUserAndTime(tweet.user.name, tweet.user.screen_name, tweet.created_at);

})

