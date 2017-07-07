'use strict';
define(['powerUp'], function(powerUp) {

    powerUp.controller('ReviewCtrl', function($scope, Restangular, $location, AuthService) {

        Restangular.setFullResponse(true);
        $scope.canWriteReview = false;
        $scope.pageSizes = [5,10,15];
        $scope.pageSize = 5;

        $scope.userId = $location.search().userId;
        $scope.gameId = $location.search().gameId;
        if (!$scope.userId && !$scope.gameId) {
            console.log('No gameId nor userId');
            $location.search({});
            $location.path('');
        }


        // TODO delete duplicated
        if ($scope.gameId) {
            Restangular.one('games', $scope.gameId).get().then(function(response) {
                var game = response.data;
                $scope.game = game;
                console.log('Game: ', game);
                if ($scope.game !== null) {
                    // $scope.$broadcast('gameFound');                                     // Game found, fire all secondary searches (e.g. reviews)
                } else {
                    // TODO show 'game not found'
                    $location.search({});
                    $location.path('');
                }
            }, function(response) {
                console.log('Error with status code', response.status); // TODO handle error
                $location.search({});
                $location.path('');
            });
        }
       if ($scope.userId) {
           Restangular.one('users', $scope.userId).get().then(function(response) {
               var user = response.data;
               $scope.user = user;
               console.log('User: ', user);
               if ($scope.user !== null) {
                   // $scope.$broadcast('gameFound');                                     // Game found, fire all secondary searches (e.g. reviews)
               } else {
                   // TODO show 'user not found'
                   $location.search({});
                   $location.path('');
               }
           }, function(response) {
               console.log('Error with status code', response.status); // TODO handle error
               $location.search({});
               $location.path('');
           });
       }
       $scope.overallReviewScore = function(review) {
            var fields = ['storyScore', 'graphicsScore', 'audioScore', 'controlsScore', 'funScore'];
            var result = 0;

            fields.forEach(function(field) {
                result += review[field] / fields.length;
            });
            return result;
        };
        $scope.canDeleteReview = function(review) {
            return AuthService.isLoggedIn() && AuthService.getCurrentUser().username === review.username;
        };

        /**
         * Check if the user is logged. If he is, check if he can write a review by checking if he has another review already written.
         * Set the variable $scope.canWriteReview to true if he can write a review and to false if he cannot.
         */
        $scope.checkCanWriteReview = function() {
            if ($scope.userId || !AuthService.isLoggedIn() || !$scope.gameId) {
                $scope.canWriteReview = false;
            } else {
                var currentUserUsername = AuthService.getCurrentUser().username;
                Restangular.all('reviews').getList({username: currentUserUsername, gameId: $scope.gameId}).then(function (response) {
                    var reviews = response.data;
                    if (reviews.length > 0) {
                        $scope.canWriteReview = false;
                    } else {
                        $scope.canWriteReview = true;
                    }
                }, function(response) {
                    console.log('There was an error getting reviews, ', response);
                    $scope.canWriteReview = false;
                });
            }
        };

        $scope.deleteReview = function(review) {
            Restangular.one('reviews', review.id).remove().then(function(response) {
                var data = response.data;
                $log.info('Success: ', data);
                $scope.reviews = $scope.reviews.filter(function(reviewToFilter) {
                    return reviewToFilter.id !== review.id;
                });
            },
            function(error) {
                $log.error('Error: ', error);
            },function () {
                $scope.checkCanWriteReview();
            });
        };


        Restangular.all('reviews').getList({gameId: $scope.gameId, userId: $scope.userId, pageSize: 1}).then(function (response) {
            var reviews = response.data;
            $scope.reviews = reviews;
            console.log('foundReviews', reviews);
            $scope.headersPagination = response.headers();
            console.log($scope.headersPagination);
            $scope.checkCanWriteReview();
            $scope.updatePagination();
        }, function() {
            console.log('There was an error getting reviews');
        });

       $scope.updatePagination = function() {
           // Show the fist ten
           $scope.paginationJustOne = ($scope.headersPagination['x-page-number'] - 4 <= 0) || ($scope.headersPagination['x-total-pages'] <= 10);
           // Show the last ten
           $scope.paginationNoMorePrev = ($scope.headersPagination['x-page-number'] + 5 > $scope.headersPagination['x-total-pages']);
           $scope.paginationTheFirstOnes = ($scope.headersPagination['x-page-number'] + 5 < 10);
           $scope.paginationNoMoreNext = ($scope.headersPagination['x-page-number'] + 5 >= $scope.headersPagination['x-total-pages']) || ($scope.headersPagination['x-total-pages'] < 10);

           if ($scope.paginationJustOne) {
               $scope.paginationBegin = 1;
           } else {
               $scope.paginationBegin = $scope.paginationNoMorePrev ? $scope.headersPagination['x-total-pages'] - 9 : $scope.headersPagination['x-page-number'] - 4;
           }

           if ($scope.paginationNoMoreNext) {
               $scope.paginationEnd = $scope.headersPagination['x-total-pages'];
           } else {
               $scope.paginationEnd = $scope.paginationTheFirstOnes ? 10 : $scope.headersPagination['x-page-number'] + 5;
           }

           $scope.rangePagination = [];
           for (var i = $scope.paginationBegin; i < $scope.paginationEnd; i++) {
               $scope.rangePagination.push(i);
           }
       }

    });

});
