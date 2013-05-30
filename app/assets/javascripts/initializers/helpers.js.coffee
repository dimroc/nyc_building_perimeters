Helpers = window.Helpers = {}

Helpers.getTypeName = (obj) ->
   funcNameRegex = /function (.{1,})\(/
   results = (funcNameRegex).exec(obj.constructor.toString())
   if results && results.length > 1 then results[1] else ""

Helpers.slugify = (string) ->
  value = string.replace(/\ /g, '-')
  value = value.replace(/\./g, '')
  value = value.replace(/'/g, '-')
  value
