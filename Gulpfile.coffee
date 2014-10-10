"use strict"

browserify = require "browserify"
gulp       = require "gulp"
uglify     = require 'gulp-uglify'
source     = require "vinyl-source-stream"
buffer     = require "vinyl-buffer"

gulp.task "browserify", ->
  bundler = browserify
    entries: [
      "./source/micro.coffee"
    ]
    extensions: ['.coffee']
    debug: true

  bundler.bundle()
    .pipe source "micro.js"
    .pipe buffer()
    .pipe gulp.dest "./build"

  bundler.bundle()
    .pipe source "micro.min.js"
    .pipe buffer()
    .pipe uglify()
    .pipe gulp.dest "./build"