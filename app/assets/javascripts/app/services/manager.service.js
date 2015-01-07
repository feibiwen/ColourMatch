function Manager($timeout, UploadPhoto, SendColour) {
  var Manager  = this;
  this.state   = 0;
  this.states  = {
    idle:          0,
    uploading:     1,
    done:          2
  };
  this.photos  = [];

  this.mode    = null; // Either 'photo' or 'colour'  

  this.photo   = null;
  this.palette = null;

  this.colour  = null;
  this.closestColour = null;

  this.requestPath = "/photos";



  this.requestImages = function(search, token, type) {
    var request_string;

    Manager.state = Manager.states.uploading;
    Manager.mode  = type;

    if (type == 'photo') {
      UploadPhoto.call(search, token)
      .success(function(data, status, headers, config) {
        // file is uploaded successfully
        Manager.photo   = config.file;
        Manager.palette = data.colours;
        Manager.stats   = data.stats;

        console.log("DATA", data)

        Manager.requestPath += "?mode_data=" + data.stats.id + "&mode=photo";

        // The second server request happens when Manager.state gets updated in Manager#updateAfterInterval.
        // There's a watch function in dash.ctrl.js
        Manager.updateAfterInterval(Manager.states.done);

      });
      //.error(...)
      //.then(success, error, progress); // returns a promise that does NOT have progress/abort/xhr functions
      //.xhr(function(xhr){xhr.upload.addEventListener(...)}) // access or attach event listeners to the underlying XMLHttpRequest
    
    } else if (type == 'colour') {
      console.log("COLOUR IS ", Manager.colour);
      SendColour.call(search, token)
      .$promise.then(function(successResult) {
        Manager.closestColour = successResult.closest_colour;

        Manager.requestPath  += "?mode_data=" + Manager.colour.replace("#", "") + "&mode=colour";
        
        
        // The second server request happens when Manager.state gets updated in Manager#updateAfterInterval.
        // There's a watch function in dash.ctrl.js
        Manager.updateAfterInterval(Manager.states.done);
        
      }, function(errorResult) {
        console.log(errorResult);
      });
    }
  };

  this.updateAfterInterval = function(desiredState) {
    var minTimeToWait = 700;

    $timeout(function() {
      Manager.state = desiredState;
    }, minTimeToWait)
  };


}

angular.module('colourMatch').service("Manager", ["$timeout", "UploadPhoto", "SendColour", Manager]);