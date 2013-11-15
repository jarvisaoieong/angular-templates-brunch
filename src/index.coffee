module.exports = class NgTemplatesCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'html'
  # Add to this list of markup to wrap for AngularJS
  pattern: /\.(html|jade|md|eco|hbs|handlebars)$/

  constructor: (config) ->
    @module = config.plugins?.ng_templates?.module or 'appTemplates'

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
          // Avoid __templateData from tempering with the environment
          var define = void 0, module = void 0;
          // The template getter: assume `__templateData` is a function
          // returning the template content
          #{data}
          // Save the template content
          $templateCache.put('#{path}', __templateData());
        });
      })();
    """
