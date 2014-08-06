path = require 'path'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    meta:
      build  : 'build'
      dist   : 'dist'
      name   : 'micro'
      source : 'source'
      specs  : 'specs'

    source:
      specs  : '<%= meta.specs %>/*.spec.coffee'

    bower:
      dist   : path.normalize(__dirname + '/..') + '/bower-<%= meta.name %>'

    coffee:
      specs  : files: '<%= meta.build %>/<%= meta.name %>.spec.js' : '<%= source.specs %>'

    clean:
      build  : src: ['build']
      dist   : src: ['dist']

    copy:
      dist   : src: '<%= meta.dist %>/*', dest: '<%= bower.dist %>/', expand: true, flatten: true
      bower  : src: 'bower.json', dest: '<%= bower.dist %>/'
      readme : src: 'README.md', dest: '<%= bower.dist %>/'
      license: src: 'LICENSE.md', dest: '<%= bower.dist %>/'

    browserify:
      dist:
        files: 'dist/micro.js' : ['source/micro.coffee']

    uglify:
      options: mangle: true, report: 'gzip'
      micro  : files: '<%= meta.dist %>/<%= meta.name %>.min.js' : '<%= meta.dist %>/<%= meta.name %>.js'

    jasmine:
      pivotal:
        src: ['<%= meta.dist %>/<%= meta.name %>.js']
        options: specs: '<%= meta.build %>/<%= meta.name %>.spec.js'

    watch:
      specs:
        files: ['<%= meta.source %>/*.coffee', '<%= meta.specs %>/*.coffee']
        tasks: ['coffee', 'browserify', 'jasmine']

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-jasmine'
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'test', ['clean', 'coffee', 'browserify', 'jasmine']
    grunt.registerTask 'bower', ['default', 'copy', 'clean']
    grunt.registerTask 'default', ['clean', 'coffee', 'browserify', 'uglify', 'jasmine', 'clean:build']