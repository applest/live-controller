angular
  .module('liveController', [])
  .controller('MainCtrl', ['$scope', '$http', '$interval', '$timeout',
    ($scope, $http, $interval, $timeout) ->
      input = parseInt(location.hash.substr(1))
      $scope.targetChannel = { device: 0, input: input }

      defaultSuccess = (data) ->
        # console.log(data)

      $scope.isProgramChannel = (channel) ->
        channel.input == $scope.state[0].video.programInput

      $scope.isPreviewChannel = (channel) ->
        channel.input == $scope.state[0].video.previewInput

      $scope.getChannelInput = (channel) ->
        $scope.state[channel.device].channels[channel.input]

      $scope.changeProgramInput = (channel) ->
        $http.post('/api/changeProgramInput', device: channel.device, input: channel.input).success(defaultSuccess)

      $scope.refresh = ->
        $http.get('/api/switchersStatePolling').success((data) ->
          $scope.state = data
          $timeout($scope.refresh, 0)
        )
      $timeout($scope.refresh, 0)

      $interval( ->
        $http.get('/api/switchersState').success((data) ->
          $scope.state = data
        )
      , 500)
  ])
