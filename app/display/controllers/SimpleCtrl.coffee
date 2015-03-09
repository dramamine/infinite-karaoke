
angular.module('karaoke.display').controller 'SimpleCtrl', [
  '$scope',
  ($scope) ->

    $scope.lyricOne =
      line: "LINE ONE"
      action: null

    $scope.lyricTwo =
      line: "LINE TWO"
      action: null

    lyrics = ['I TRIED SO HARD', 'AND LOST IT ALL', 'BUT IN THE END', 'IT DOESNT EVEN MATTER', 'I TRIED SO HARD', 'AND LOST IT ALL', 'BUT IN THE END', 'IT DOESNT EVEN MATTER' ]

    $scope.people = []

    counter = 0
    $scope.addSome = () ->
      if( $scope.people.length >= 4 )
        $scope.people.splice 0,1,
          lyric: lyrics[counter]

      else
        $scope.people.push(
          lyric: lyrics[counter]
        )

      counter++
      if( counter >= 8 )
        counter=0



    $scope.updateOne = (action) ->
      $scope.lyricOne.action = action
    $scope.updateTwo = (action) ->
      $scope.lyricTwo.action = action

    $scope.imdone = (idx) ->
      console.log 'imdone called for ' + idx
      switch(idx)
        when 1
          if( $scope.lyricOne.action == "exiting")
            $scope.lyricOne.action = "gone"
        when 2
          if( $scope.lyricTwo.action == "exiting")
            $scope.lyricTwo.action = "gone"


    $scope.animCallback = (idx) ->
      console.log 'animCAllback with index ' + idx
      return null

]
