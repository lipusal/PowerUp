'use strict';
define(['powerUp'], function(powerUp) {

    powerUp.controller('ThreadCtrl', function($scope, Restangular, SessionService, $location) {
        Restangular.setFullResponse(false);
        $scope.thread = {creator: {username: '<h1>Hello</h1>', id: '1'},id: 1,comments: [],initialComment: 'MI PRIMER COMENTARIO',title: 'EL TITULO', createdAt: '2016-1-13', likeCount: 3};

        $scope.isLoggedIn = SessionService.isLoggedIn;
        $scope.getCurrentUser = SessionService.getCurrentUser;

        $scope.isLikedByCurrentUser = function(thread) {
            return true;   // TODO
        };

        $scope.unlikeThread = function() {

        };
        $scope.likeThread = function() {

        };
        $scope.changeTitle = function() {

        };
        $scope.deleteThread = function() {

        };
        $scope.editComment = function() {

        };
    });
});
