// adapted from https://gist.github.com/adaline/7363853 which read the image from a file
// modified to support posting to twitter update_with_media - with image from s3 rather than a
// local file.
 
(function() {
  var fs, path, request, twittermedia;
 
  fs = require('fs');
 
  path = require('path');
 
  request = require('request');
 
 
  twittermedia = (function() {
    function twittermedia(auth_settings) {
      this.auth_settings = auth_settings;
      this.api_url = 'https://api.twitter.com/1.1/statuses/update_with_media.json';
    }

     twittermedia.prototype.postURLImage = function(status, imageUrl, callback) {
      var form, r;
      r = request.post(this.api_url, {
        oauth: this.auth_settings
      }, callback);
      form = r.form();
      form.append('status', status);
      return form.append('media[]', request(imageUrl));
    };


    twittermedia.prototype.postLocalImage = function(status, file_path, callback) {
      var form, r;
      r = request.post(this.api_url, {
        oauth: this.auth_settings
      }, callback);
      form = r.form();
      form.append('status', status);
      return form.append('media[]', fs.createReadStream(path.normalize(file_path)));
    };

    return twittermedia;
 
  })();
 
  module.exports = twittermedia;
 
}).call(this);