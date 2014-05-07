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
      micro  : '<%= meta.source %>/<%= meta.name %>.coffee'
      utils  : '<%= meta.source %>/<%= meta.name %>.utils.coffee'
      ajax   : '<%= meta.source %>/<%= meta.name %>.ajax.coffee'
      specs  : '<%= meta.specs %>/*.spec.coffee'

    coffee:
      micro  : files: '<%= meta.build %>/<%= meta.name %>.js'       : '<%= source.micro %>'
      utils  : files: '<%= meta.build %>/<%= meta.name %>.utils.js' : '<%= source.utils %>'
      ajax   : files: '<%= meta.build %>/<%= meta.name %>.ajax.js'  : '<%= source.ajax %>'
      specs  : files: '<%= meta.build %>/<%= meta.name %>.spec.js'  : '<%= source.specs %>'

    clean:
      build  : src: ['build']
      dist   : src: ['dist']

    uglify:
      options: mangle: true, report: 'gzip'
      micro  : files: '<%= meta.dist %>/<%= meta.name %>.js'       : '<%= meta.build %>/<%= meta.name %>.js'
      utils  : files: '<%= meta.dist %>/<%= meta.name %>.utils.js' : '<%= meta.build %>/<%= meta.name %>.utils.js'
      ajax   : files: '<%= meta.dist %>/<%= meta.name %>.ajax.js'  : '<%= meta.build %>/<%= meta.name %>.ajax.js'

    jasmine:
      pivotal: src: [
        '<%= meta.build %>/<%= meta.name %>.js'
        '<%= meta.build %>/<%= meta.name %>.utils.js'
        '<%= meta.build %>/<%= meta.name %>.ajax.js'
      ]
      options: specs: '<%= meta.build %>/<%= meta.name %>.spec.js'

    watch:
      specs: files: [
        '<%= meta.source %>/*.coffee',
        '<%= meta.specs %>/*.coffee'
      ]
      tasks: ['coffee', 'jasmine']

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-jasmine'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'test', ['clean', 'coffee', 'jasmine']
    grunt.registerTask 'default', ['clean', 'coffee', 'uglify', 'jasmine']