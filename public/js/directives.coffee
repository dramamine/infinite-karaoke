'use strict';

# Directives
app = angular.module 'allDirectives', []

app.directive('youtuber', ($sce)->
  return {
    restrict: 'EA'
    scope:
      code:'='
    replace: true
    template: '<div style="height:400px;"><iframe style="overflow:hidden;height:100%;width:100%" width="100%" height="100%" ng-src="{{url}}" frameborder="0" allowfullscreen></iframe></div>'
    link: (scope) ->
      console.log 'here is my directive being loaded.'
      # console.log scope
      scope.$watch 'code', (newVal) ->

        if newVal
          console.log 'got code!'
          scope.url = $sce.trustAsResourceUrl("http://www.youtube.com/v/" + newVal + "?version=3&enablejsapi=1")

      scope.$watch 'trackid', (newVal) ->

        if newVal
          console.log 'got trackid ' + newVal
          # look it up in the db
          
      
      return null
  }
)