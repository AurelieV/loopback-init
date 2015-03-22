angular.module 'my-app.homepage'
.controller 'homepageController',
  ($scope, Member, $mdDialog) ->
    Member.find {}
    , (members) ->
      $scope.members = members
    , (err) ->
      console.log 'err', err

    $scope.add = ($event) ->
      $mdDialog.show
        templateUrl: 'homepage/add/view.html'
        targetEvent: $event
        clickOutsideToClose: false
        controller: 'addOrEditMemberController'
        locals:
          edit: false
          member: null
      .then (member) ->
        $scope.members.push member

    $scope.edit = ($event, member) ->
      $mdDialog.show
        templateUrl: 'homepage/add/view.html'
        targetEvent: $event
        clickOutsideToClose: false
        controller: 'addOrEditMemberController'
        locals:
          edit: true
          member: member
      .then (member) ->
        console.log member     


angular.module 'my-app.homepage'
.controller 'addOrEditMemberController'
, ($scope, $mdDialog, Member, edit, member) -> 
  $scope.member = angular.copy member if edit
  delete $scope.member.id if edit
  $scope.isNew = !edit
  $scope.cancel = ($event)->
    $event.preventDefault()
    $mdDialog.cancel()
  $scope.create = ($event) ->
    Member.create $scope.member
    , (member) ->
      $mdDialog.hide(member)
    , (err) ->
      console.log 'error', err
  $scope.edit = ($event) ->
    Member.update {where:{id: member.id}}
    , $scope.member
    , (memberUpdate) ->
      angular.copy $scope.member, member
      $mdDialog.hide(memberUpdate)
    , (err) ->
      console.log 'error' 
