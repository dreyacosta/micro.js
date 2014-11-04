"use strict"

path         = require "path"
browserify   = require "browserify"
gulp         = require "gulp"
uglify       = require "gulp-uglify"
coffee       = require "gulp-coffee"
concat       = require "gulp-concat"
karma        = require("karma").server
sourceStream = require "vinyl-source-stream"
buffer       = require "vinyl-buffer"

meta =
  build  : "build"
  dist   : "dist"
  name   : "micro"
  source : "source"
  specs  : "specs"

source =
  all   : "./" + meta.source + "/*.coffee"
  micro : "./" + meta.source + "/" + meta.name + ".coffee"
  specs : "./" + meta.specs + "/*.spec.coffee"

dist = [
  "./" + meta.dist + "/" + meta.name + ".js"
  "./" + meta.dist + "/" + meta.name + ".min.js"
  "./bower.json"
  "./LICENSE.md"
  "./README.md"
]

test = [
  "./" + meta.build + "/micro.js"
  "./" + meta.build + "/micro.spec.js"
]

bower = path.normalize(__dirname + "/..") + "/bower-" + meta.name

gulp.task "browserify", ->
  bundler = browserify
    entries: [
      source.micro
    ]
    extensions: [".coffee"]
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

gulp.task "specs", ->
  gulp.src source.specs
    .pipe concat "micro.spec.coffee"
    .pipe coffee()
    .pipe gulp.dest meta.build

gulp.task "test", ["browserify", "specs"], (done) ->
  karma.start
    autoWatch: "disable"
    basePath: "./"
    browsers: ["PhantomJS"]
    colors: true
    files: test
    frameworks: ["jasmine"]
    port: 8001
    reporters: ["progress"]
    singleRun: true
  , done

gulp.task "default", ->
  gulp.watch source.all, ["test"]
  gulp.watch source.specs, ["test"]