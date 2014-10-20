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

source =
  micro: "./" + meta.source + "/" + meta.name + ".coffee"
  specs: "./" + meta.specs + "/" + meta.name + ".specs.js"

gulp.task "browserify", ->
  pa2 = path.normalize(__dirname + '/..') + '/bower-micro'

  bundler = browserify
    entries: [
      source.micro
    ]
    extensions: ['.coffee']
    debug: true

  bundler.bundle()
    .pipe sourceStream meta.name + ".js"
    .pipe buffer()
    .pipe gulp.dest meta.build

  bundler.bundle()
    .pipe sourceStream meta.name + ".min.js"
    .pipe buffer()
    .pipe uglify()
    .pipe gulp.dest meta.dist

gulp.task "copy", ->
  gulp.src ['./build/micro.js']
    .pipe copy './dist'