
angular.module('karaoke.display').directive 'youtuber', ($sce) ->
  return {
    restrict: 'EA'
    scope:
      code:'='
    replace: true
    templateUrl: '../partials/youtube.html'
    link: (scope) ->
      scope.$watch 'code', (code) ->
        if code
          scope.url = $sce.trustAsResourceUrl('http://www.youtube.com/v/' +
            code + '?version=3&enablejsapi=1')
      return null
  }