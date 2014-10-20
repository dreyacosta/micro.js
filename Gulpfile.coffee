"use strict"

path         = require "path"
browserify   = require "browserify"
gulp         = require "gulp"
uglify       = require 'gulp-uglify'
copy         = require 'gulp-copy'
sourceStream = require "vinyl-source-stream"
buffer       = require "vinyl-buffer"

meta =
  build  : 'build'
  dist   : 'dist'
  name   : 'micro'
  source : 'source'
  specs  : 'specs'

source_ =
  micro: meta.source + '/' + meta.name + '.coffee'

gulp.task "browserify", ->
  pa2 = path.normalize(__dirname + '/..') + '/bower-micro'

  bundler = browserify
    entries: [
      "./source/micro.coffee"
    ]
    extensions: ['.coffee']
    debug: true

  bundler.bundle()
    .pipe sourceStream meta.name + '.js'
    .pipe buffer()
    .pipe gulp.dest meta.build

  bundler.bundle()
    .pipe sourceStream "micro.min.js"
    .pipe buffer()
    .pipe uglify()
    .pipe gulp.dest pa2

gulp.task "copy", ->
  gulp.src ['./build/micro.js']
    .pipe copy './dist'