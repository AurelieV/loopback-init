angular.module 'my-app.seasons'
.controller 'seasonsController', ($scope, seasons, $mdDialog) ->
  $scope.seasons = seasons

  $scope.add = ($event) ->
    $mdDialog.show
      templateUrl: 'seasons/add/view.html'
      targetEvent: $event
      clickOutsideToClose: false
      controller: 'addSeasonController'
    .then (season) ->
      $scope.seasons.push season
      $mdToast.showSimple "#{season.name} créé"

angular.module 'my-app.seasons'
.controller 'addSeasonController'
, ($scope, $mdDialog, Season) -> 
  $scope.cancel = ($event)->
    $event.preventDefault()
    $mdDialog.cancel()
  $scope.create = ($event) ->
    Season.create $scope.season
    , (season) ->
      $mdDialog.hide(season)
    , (err) ->
      $mdToast.showSimple "Impossible de créer la saison"
  
     
