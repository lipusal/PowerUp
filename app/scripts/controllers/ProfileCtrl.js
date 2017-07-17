'use strict';
define(['powerUp', 'AuthService', 'sweetalert.angular'], function(powerUp) {

    powerUp.controller('ProfileCtrl', ['$scope', '$location', '$timeout', '$log', 'Restangular', 'AuthService', function($scope, $location, $timeout, $log, Restangular, AuthService) {
        Restangular.setFullResponse(true);
        $scope.Restangular = Restangular;
        $scope.AuthService = AuthService;

        $scope.isCurrentUser = AuthService.isCurrentUser;

        $scope.userId = $location.search().userId;
        $scope.username = $location.search().username;
        $scope.currentUser = AuthService.getCurrentUser();

        // All profile-specific info will go here
        $scope.profile = {
            gamesInList:0,
            picture: {
                url: null,
                data: null,
                temp: null,
                canDelete: false
            }
        };

        // Form control variables
        $scope.pictureSubmitDisabled = false;
        var deleteProfilePictureDisabled = false;
        var resettingPassword = false;
        var DEFAULT_PROFILE_PICTURE_URL = 'http://res.cloudinary.com/dtbyr26w9/image/upload/v1476797451/default-cover-picture.png';

        Restangular.one('users').one('username', $scope.username).get().then(function(response) {
            var user = response.data;
            if (!user) {
                $log.warn('Received null user, redirecting to home');
                $location.search({});
                $location.path('');
            }
            $scope.requestedUser = user;
            Restangular.one('users', user.id).getList('game-list').then(function(response) {
                $scope.profile.gamesAmount = parseInt(response.headers()['x-total-pages'], 10);
                if (!$scope.profile.gamesAmount) {
                    $scope.profile.gamesAmount = 0;
                }
            });
            $scope.profile.picture.url = getProfilePictureUrl(user.id);
            $scope.profile.picture.canDelete = canDeleteProfilePicture($scope.profile.picture.url);
            getTopGames();
        }, function(response) {
            $log.error('Error retrieving user: ', response); // TODO handle error
            $location.search({});
            $location.path('');
        });

        $scope.parseProfilePicture = function(file) {
            if (!file) {
                return;
            }

            var r = new FileReader();
            $scope.pictureSubmitDisabled = true;
            r.onloadend = function(e) {
                var pictureBase64 = e.target.result;
                $timeout(function() {
                    $scope.pictureSubmitDisabled = false;
                    $scope.profile.picture.temp = pictureBase64;
                });
            };
            r.readAsDataURL(file);
        };

        $scope.uploadProfilePicture = function() {
            var data = $scope.profile.picture.temp;
            if (!data || !$scope.canChangePicture()) {
                return;
            }

            $scope.pictureSubmitDisabled = true;
            Restangular.one('users').one('picture').customPUT(data).then(function (response) {
                $scope.pictureSubmitDisabled = false;
                $scope.profile.picture.canDelete = true;

                // Load the profile picture from own computer, no need to re-retrieve picture
                $scope.profile.picture.data = $scope.profile.picture.temp;
                $scope.profile.picture.temp = null;
                $scope.profile.picture.url = null;
            }, function (error) {
                $log.error('Profile picture upload error: ', error);
                $scope.pictureSubmitDisabled = false;
            });
        };

        $scope.deleteProfilePicture = function() {
            if (!$scope.profile.picture.canDelete || deleteProfilePictureDisabled) {
                return;
            }

            $scope.pictureSubmitDisabled = false;
            deleteProfilePictureDisabled = true;
            Restangular.one('users').one('picture').remove().then(function(response) {
                $timeout(function() {
                    // Reset profile picture URL to get default picture
                    $scope.profile.picture.url = DEFAULT_PROFILE_PICTURE_URL;
                    $scope.profile.picture.data = null;
                    $scope.profile.picture.temp = null;
                    $scope.profile.picture.canDelete = false;

                    $scope.pictureSubmitDisabled = false;
                    deleteProfilePictureDisabled = false;
                });
            }, function(error) {
                $log.error('Couldn\'t delete profile picture ', error);
                $scope.pictureSubmitDisabled = false;
                deleteProfilePictureDisabled = false;
            });
        };

        $scope.canChangePicture = function() {
            return $scope.requestedUser && AuthService.isCurrentUser($scope.requestedUser);
        };

        /**
         * Shows the first SWAL for resetting password. Asks for new password.
         */
        $scope.changePassword = function() {
            swal({
                    title: 'New password',
                    type: 'input',
                    inputType: 'password',
                    showCancelButton: true,
                    closeOnConfirm: false
                },
                function(inputValue) {
                    if (inputValue === false) {
                        return false;
                    } else if (inputValue === '') {
                        swal.showInputError('Please write a new password');
                        return false;
                    }

                    secondPasswordSwal(inputValue);
                });
        };

        // Follow
        $scope.canFollow = function () {
            return $scope.requestedUser && AuthService.isLoggedIn() && !AuthService.isCurrentUser($scope.requestedUser);
        };
        $scope.updateFollow = function () {
            $scope.followDisable = true;
            if (!$scope.requestedUser.social.followedByCurrentUser) {
                Restangular.one('users',$scope.requestedUser.id).one('followers').put().then(function () {
                    $scope.followDisable = false;
                    $scope.requestedUser.social.followedByCurrentUser = true;
                }, function () {
                    $scope.followDisable = false;
                });
            } else {
                Restangular.one('users',$scope.requestedUser.id).one('followers').remove().then(function () {
                    $scope.followDisable = false;
                    $scope.requestedUser.social.followedByCurrentUser = false;
                }, function () {
                    $scope.followDisable = false;
                });
            }
        };

        /* ******************************************
         *              PRIVATE FUNCTIONS
         * *****************************************/

        function getProfilePictureUrl(userId) {
            return Restangular.one('users', userId).one('picture').getRequestedUrl();
        }

        function canDeleteProfilePicture(profilePictureUrl) {
            return profilePictureUrl !== DEFAULT_PROFILE_PICTURE_URL;
        }


        function getTopGames() {
            var userId = $scope.requestedUser.id;
            if (!userId) {
                return;
            }

            /* TODO sort by descending user score */
            Restangular.one('users', userId).getList('game-scores', {pageSize: 10}).then(function(response) {
                $scope.profile.top10 = response;
            });
        }

        /**
         * Shows the second password change SWAL. The input password must match the provided new password. On cancel,
         * goes back to the first SWAL. On confirm, hits API.
         *
         * @param newPassword   The new password, as input in {@link firstPasswordSwal()}. Must match that.
         */
        function secondPasswordSwal(newPassword) {
            if(resettingPassword) {
                return;
            }
            swal({
                title: 'Confirm password',
                type: 'input',
                inputType: 'password',
                showCancelButton: true,
                closeOnConfirm: false,
                closeOnCancel: false,
                cancelButtonText: 'Go Back'
            },
            function(inputValue) {
                if (inputValue === false) {
                    // Pressed cancel
                    $scope.changePassword();
                    return;
                }

                if (inputValue === '') {
                    swal.showInputError('Please write your new password again');
                    return false;
                } else if (inputValue !== newPassword) {
                    swal.showInputError('Passwords don\'t match');
                    return false;
                }

                // Confirmed, hit API
                swal.disableButtons();
                resettingPassword = true;

                Restangular.all('users').customPUT({password: inputValue}, 'password').then(function(response) {
                    swal('Password Changed!', undefined, 'success');
                    resettingPassword = false;
                }, function(error) {
                    swal.showInputError('Server error, please try again');
                    $log.error('Error resetting password: ', error);
                    resettingPassword = false;
                });
            });
        }
    }]);

});
