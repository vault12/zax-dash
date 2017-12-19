angular.module('app', [])

# filter to test object emptiness
angular.module('app').filter 'isEmpty', ->
  (obj) ->
    for key of obj
      if obj.hasOwnProperty(key)
        return false
    true
