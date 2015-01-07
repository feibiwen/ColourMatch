function UploadPhoto($upload, SetImagePreview) {
  var serv = this;

  this.call = function(photo, token) {
    SetImagePreview.call(photo);    
    return $upload.upload({
      url: '/photos',
      method: 'POST',
      data: {photo: photo, authenticity_token: token},
      file: photo, 
      fileFormDataName: "photo", 
      formDataAppender: function(formData) {
        formData.append("authenticity_token", token);
        formData.append("photo", photo);
      } 

    });

  };


}

angular.module('colourMatch').service("UploadPhoto", ["$upload", "SetImagePreview", UploadPhoto]);