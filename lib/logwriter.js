(function() {
  var fs, path, logwriter;
 
  fs = require('fs');
 
  path = require('path');
 
  
  logwriter = (function(file_name) {
    function logwriter(log_file_name, callback) {
      this.log_file_name = log_file_name;
      var self = this;
      fs.exists('./logs/' + self.log_file_name, function(exists) {
        if (exists) {
          // file was created before
          console.log('File ' + self.log_file_name + ' exists!' );
        } else {
          // file was created new
          var datetime = new Date();
          var open_text = '{ started_at: ' + datetime + ' } \n';
          fs.writeFileSync('./logs/' + self.log_file_name, open_text);
          /*
          fs.writeFileSync('./logs/' + self.log_file_name, open_text, function(err) {
            if(err) {
            console.log(err);
          } else {
            console.log('The file was saved!');
          }
          });
          */ 
        }
      });
      
    }

    logwriter.prototype.writeToLog = function(log_text) {
      var self = this;
      fs.writeFile('./logs/' + self.log_file_name, log_text, function(err) {
        if(err) {
        console.log(err);
      } else {
        console.log('The file was saved!');
      }
      }); 
    };

    logwriter.prototype.writeUserAndTime = function(log_name, log_screenname, log_createdat) {
      var self = this;
      var log_text = 'tweeted_info: { \n' +
                      '  created_at: ' + log_createdat + '\n' +
                      ', name: ' + log_name + '\n' +
                      ', screen_name: ' + log_screenname + ' }\n';
      fs.appendFile('./logs/' + self.log_file_name, log_text, function(err) {
        if(err) {
        console.log(err);
      } else {
        console.log(log_text);
      }
      }); 
    };



    return logwriter;
 
  })();
 
  module.exports = logwriter;
 
}).call(this);