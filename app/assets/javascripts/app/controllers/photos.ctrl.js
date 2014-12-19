function PhotosController($scope, $attrs, Photos) {
  this.photo = null;
  this.auth  = $attrs.authToken;

  var ctrl   = this;

  $scope.$watch(angular.bind(this, function() {
    return this.photo;
  }), function(newVal, oldVal) {
    console.log("Watch triggered with ", newVal);
    if (newVal) {
      $scope.upload = Photos.upload(newVal, ctrl.auth);
    }
  });


}





PhotosController.$inject = ['$scope', '$attrs', 'Photos'];
angular.module('colourMatch').controller('PhotosController', ['$scope', '$attrs', 'Photos', PhotosController]);