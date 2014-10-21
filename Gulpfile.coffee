"use strict"

path         = require "path"
browserify   = require "browserify"
gulp         = require "gulp"
uglify       = require 'gulp-uglify'
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

dist = [
  "./" + meta.dist + "/" + meta.name + ".js"
  "./" + meta.dist + "/" + meta.name + ".min.js"
  "./bower.json"
  "./LICENSE.md"
  "./README.md"
]

bower = path.normalize(__dirname + "/..") + "/bower-" + meta.name

gulp.task "browserify", ->
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
    .pipe gulp.dest meta.dist
    .pipe gulp.dest bower

  bundler.bundle()
    .pipe sourceStream meta.name + ".min.js"
    .pipe buffer()
    .pipe uglify()
    .pipe gulp.dest meta.dist
    .pipe gulp.dest bower

gulp.task "bower", ->
  gulp.src dist
    .pipe gulp.dest bower