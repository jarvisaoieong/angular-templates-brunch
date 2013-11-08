module.exports = class NgTemplatesCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'html'
  pattern: /\.(html|jade|md|eco|hbs|handlebars)$/

  constructor: (config) ->
    @module = config.plugins?.ngTemplates?.module or 'app.templates'

  compile: (data, path, callback) ->
    callback null, """
      (function() {
        try {
          // Get current templates module
          var module = angular.module('#{@module}');
        } catch (error) {
          // Or create a new one
          var module = angular.module('#{@module}', []);
        }

        module.run(function($templateCache) {
          // Save the template
          $templateCache.put('#{path}', unescape('#{escape(data)}'));
        });
      })();
    """
