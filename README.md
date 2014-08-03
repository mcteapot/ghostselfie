// CHANGES MADE TO twit > twitter.js

  postMediaRequestURL: function(request, status, imageUrl, callback) {
      var form, r;
      r = request.post(this.api_url, {
        oauth: this.auth_settings
      }, callback);
      form = r.form();
      form.append('status', status);
      return form.append('media[]', request(imageUrl));
  },
  postMediaRequestFilePath: function(request, status, file_path, callback) {
      var form, r;
      r = request.post(this.api_url, {
        oauth: this.auth_settings
      }, callback);
      form = r.form();
      form.append('status', status);
      return form.append('media[]', fs.createReadStream(path.normalize(file_path)));
  },
    postReplyMediaRequestFilePath: function(request, id, status, file_path, callback) {
      var form, r;
      r = request.post(this.api_url, {
        oauth: this.auth_settings
      }, callback);
      form = r.form();
      form.append('status', status);
      form.append('in_reply_to_status_id', id);
      return form.append('media[]', fs.createReadStream(path.normalize(file_path)));
  },   