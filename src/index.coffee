sysPath = require 'path'
mkdirp  = require 'mkdirp'
fs = require 'fs'
_ = require 'lodash'

module.exports = class NgTemplatesCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'html'

  constructor: (config) ->
    @module = config.plugins?.ngTemplates?.module or 'app.templates'

  optimize: (data, path, callback) ->
    console.log @module
    templatized = """
      var module = angular.module(#{@module});
      if (!module) {
        module = angular.module(#{@module}, []);
      }

      module.run(function($templateCache) {
        $templateCache.put('#{path}', unescape('#{escape(data)}'));
      });
    """
    callback null, templatized
