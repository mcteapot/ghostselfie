var fs = require('fs');
var path = require('path');
var twit = require('twit')
var request = require('request');

var config1 = require('twit/config1')

var logwriter = require('./lib/logwriter')

// Inits
var Twit = new twit(config1);

var LogWriter = new logwriter('ghostLog.txt');

console.log(config1);

/*
console.log("TRACKING #therecameanecho")

var stream = Twit.stream('statuses/filter', { track: '#ghostselfie' })

stream.on('tweet', function (tweet) {
  console.log(tweet)
  console.log(tweet.user.name)
})
*/