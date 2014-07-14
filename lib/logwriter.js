(function() {
  var fs, path, logwriter;
 
  fs = require('fs');
 
  path = require('path');
 
  
  logwriter = (function(file_name) {
    function logwriter(log_file_name) {
      this.log_file_name = log_file_name;
      var self = this
      fs.exists('./logs/' + self.log_file_name, function(exists) {
        if (exists) {
          // file was created before
          console.log('File ' + self.log_file_name + ' exists!' );
        } else {
          // file was created new
          var datetime = new Date();
          var open_text = '{ started_at: ' + datetime + ' }'
          fs.writeFile('./logs/' + self.log_file_name, open_text, function(err) {
            if(err) {
            console.log(err);
          } else {
            console.log('The file was saved!');
          }
          }); 
        }
      });
      
    }

     logwriter.prototype.writeToLog = function() {
      console.log('test function');
    };



    return logwriter;
 
  })();
 
  module.exports = logwriter;
 
}).call(this);