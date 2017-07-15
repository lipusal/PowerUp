'use strict';
define(['powerUp', 'slick-carousel', 'onComplete', 'feedService'], function(powerUp) {

	powerUp.controller('HomeCtrl', function($scope, $location, Data, searchedTitleService, Restangular, SweetAlert, AuthService, FeedService) {
	    // SweetAlert.swal("BAM!");
		Restangular.setFullResponse(true);
		$scope.homePageText = 'This is your homepage';
		$scope.data = Data;
		$scope.gameTitle = '';
		$scope.submitSearch = function() {
			searchedTitleService.setTitle($scope.gameTitle);
			$location.search({'name': $scope.gameTitle});
			$location.path('search');
      	};

      	if (AuthService.isLoggedIn()) {
			$scope.user = AuthService.getCurrentUser();
			Restangular.all('users').one('username',$scope.user.username).get().then(function (response) {
				var user = response.data;
				Restangular.one('users',user.id).all('recommended-games').getList({}).then(function (response) {
					var recommendedGames = response.data;
					$scope.recommendedGames = recommendedGames;
					$scope.recommendedMin = Math.min($scope.recommendedGames.length, 5);
				});
			});
		}

		$scope.$on('recommendedRendered', function(event) {
			angular.element('#recommended-carousel').slick({
				infinite: false,
				arrows: true
			});
			require(['lightbox2']); // TODO ensure requirejs doesn't load this twice
		});
		$scope.feed = [];
		var feedObj;
		$scope.feedNeeded = 0;
		if (AuthService.isLoggedIn()) {
			feedObj = FeedService.initialize(AuthService.getCurrentUser().id);
			$scope.feedNeeded = 10;
		}

		$scope.$watch('needFeed()', function () {
			if (AuthService.isLoggedIn() && feedObj !== null) {
				while ($scope.feedNeeded > 0 && FeedService.isReady(feedObj)) {
					$scope.feedNeeded--;
					var element = FeedService.getFeedElement(feedObj);
					if (element !== null) {
						$scope.feed.push(element);
					}
				}
			}
		});

		$scope.needFeed = function() {
			if (feedObj === null) {
				return null;
			}
			return $scope.feedNeeded + '#' + FeedService.isReady(feedObj);
		};


	});
});
