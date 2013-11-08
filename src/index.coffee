module.exports = class NgTemplatesCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'html'
  pattern: /\.(html|jade|md|eco|hbs|handlebars)$/

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
