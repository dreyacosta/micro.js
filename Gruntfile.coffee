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

    coffee:
      specs  : files: '<%= meta.build %>/<%= meta.name %>.spec.js' : '<%= source.specs %>'

    clean:
      build  : src: ['build']
      dist   : src: ['dist/**/*']

    browserify:
      dist:
        files: 'dist/micro.js' : ['source/micro.coffee']
        options:
          transform: ['coffeeify']

    uglify:
      options: mangle: true, report: 'gzip'
      micro  : files: '<%= meta.dist %>/<%= meta.name %>.min.js' : '<%= meta.dist %>/<%= meta.name %>.js'

    jasmine:
      pivotal:
        src: [
          '<%= meta.dist %>/<%= meta.name %>.js'
        ]
        options: specs: '<%= meta.build %>/<%= meta.name %>.spec.js'

    watch:
      specs:
        files: [
          '<%= meta.source %>/*.coffee',
          '<%= meta.specs %>/*.coffee'
        ]
        tasks: ['coffee', 'browserify', 'jasmine']

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-jasmine'
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'test', ['clean', 'coffee', 'browserify', 'jasmine']
    grunt.registerTask 'default', ['clean', 'coffee', 'browserify', 'uglify', 'jasmine', 'clean:build']