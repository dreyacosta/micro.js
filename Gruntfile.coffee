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
      init    : '<%= meta.source %>/<%= meta.name %>.init.coffee'
      utils   : '<%= meta.source %>/<%= meta.name %>.utils.coffee'
      specs   : '<%= meta.specs %>/<%= meta.name %>.spec.coffee'

    coffee:
      init:
        files: '<%= meta.build %>/<%= meta.name %>.init.js' : '<%= source.init %>'
      utils:
        files: '<%= meta.build %>/<%= meta.name %>.utils.js' : '<%= source.utils %>'
      specs:
        files: '<%= meta.build %>/<%= meta.name %>.spec.js': '<%= source.specs %>'

    concat:
      dist:
        src: [
          '<%= meta.dist %>/<%= meta.name %>.init.js'
          '<%= meta.dist %>/<%= meta.name %>.utils.js'
        ]
        dest: '<%= meta.dist %>/<%= meta.name %>.js'

    uglify:
      options:
        mangle: true
        report: 'gzip'
      init:
        files: '<%= meta.dist %>/<%= meta.name %>.init.js' : '<%= meta.build %>/<%= meta.name %>.init.js'
      utils:
        files: '<%= meta.dist %>/<%= meta.name %>.utils.js' : '<%= meta.build %>/<%= meta.name %>.utils.js'

    jasmine:
      pivotal:
        src: [
          '<%= meta.build %>/<%= meta.name %>.init.js'
          '<%= meta.build %>/<%= meta.name %>.utils.js'
        ]
        options:
          specs: '<%= meta.build %>/<%= meta.name %>.spec.js'

    watch:
      specs:
        files: [
          '<%= meta.source %>/*.coffee',
          '<%= meta.specs %>/*.coffee'
        ]
        tasks: ['coffee', 'jasmine']

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-jasmine'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'default', ['coffee', 'uglify', 'concat', 'jasmine']