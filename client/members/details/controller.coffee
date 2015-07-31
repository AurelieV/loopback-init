angular.module 'association-magic-board'
.controller 'membersDetailsController', ($scope, member, Member, $rootScope, Contribution, seasons, $mdToast, $state) ->
  $scope.member = member
  $scope.seasons = seasons

  $scope.back = ->
    $state.go 'members'

  $scope.edit =
    name: false
  $scope.editedMember = {}
  $scope.editedContribution = {}
  $scope.underModification = false

  $scope.editName = ->
    $scope.edit.name = true
    $scope.underModification = true
    angular.copy
      lastname: member.lastname
      firstname: member.firstname
    , $scope.editedMember

  $scope.editGlobalInfo = ->
    $scope.edit.globalInfo = true
    $scope.underModification = true
    angular.copy
      dci_number: member.dci_number
      email: member.email
      pseudo: member.pseudo
    , $scope.editedMember

  $scope.addContribution = (season) ->
    $scope.edit.contribution = true
    $scope.underModification = true
    season.isAdding = true
    $scope.newContribution =
      date: new Date()

  $scope.editContribution = (season) ->
    $scope.edit.contribution = true
    $scope.underModification = true
    season.isEditing = true
    angular.copy
      date: season.contributions[0].date
      amount: season.contributions[0].amount
    , $scope.editedContribution

  $scope.cancelName = ->
    $scope.edit.name = false
    $scope.underModification = false

  $scope.cancelGlobalInfo = ->
    $scope.edit.globalInfo = false
    $scope.underModification = false

  $scope.cancelAddContribution = (season) ->
    $scope.edit.contribution = false
    $scope.underModification = false
    season.isAdding = false

  $scope.cancelEditContribution = (season) ->
    $scope.edit.contribution = false
    $scope.underModification = false
    season.isEditing = false

  $scope.saveName = (form) ->
    return unless form.$valid
    Member.prototype$updateAttributes {id: member.id}, $scope.editedMember
    , (memberUpdated) ->
      angular.copy memberUpdated, member
      $scope.edit.name = false
      $scope.underModification = false
      $rootScope.$broadcast 'memberUpdated', member
    , (err) ->
      $mdToast.showSimple "Impossible de sauvegarder les changements"

  $scope.saveGlobalInfo = (form) ->
    return unless form.$valid
    Member.prototype$updateAttributes {id: member.id}, $scope.editedMember
    , (memberUpdated) ->
      angular.copy memberUpdated, member
      $scope.edit.globalInfo = false
      $scope.underModification = false
      $rootScope.$broadcast 'memberUpdated', member
    , (err) ->
      $mdToast.showSimple "Impossible de sauvegarder les changements"

  $scope.saveAddContribution = (form, season) ->
    return unless form.$valid
    $scope.newContribution.seasonId = season.id
    Member.contributions.create {id: member.id}, $scope.newContribution
    , (contribution) ->
      season.contributions.push contribution
      $scope.edit.addContribution = false
      $scope.underModification = false
      season.isAdding = false
      $rootScope.$broadcast 'contributionAdded', contribution
    , (err) ->
      $mdToast.showSimple "Impossible de créer la cotisations"

  $scope.saveEditContribution = (form, season) ->
    return unless form.$valid
    Contribution.prototype$updateAttributes {id: season.contributions[0].id}, $scope.editedContribution
    , (contribution) ->
      delete contribution.$promise
      delete contribution.$resolved
      angular.copy contribution, season.contributions[0]
      $scope.edit.contribution = false
      $scope.underModification = false
      season.isEditing = false
    , (err) ->
      $mdToast.showSimple "Impossible de sauvegarder les changements"

  $scope.getAmount = (season) ->
    contrib = _.find $scope.member.contributions, (contribution) ->
      contribution.seasonId is season.id
    return contrib?.amount



