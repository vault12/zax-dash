gulp = require 'gulp'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
browserSync = require('browser-sync').create()
templateCache = require 'gulp-angular-templatecache'
streamqueue = require 'streamqueue'

conf =
  dependencies: [
    'node_modules/js-nacl/lib/nacl_factory.js'
    'node_modules/theglow/dist/theglow.min.js'
    'node_modules/angular/angular.min.js'
  ]
  templates: ['src/**/*.html']
  coffee: ['src/**/*.coffee']
  target: 'build/'
  dist: 'dist/'
  watch: ['src/**/*.coffee', '**/*.html']

watching = false

gulp.task 'build', ->
  streamqueue objectMode: true,
    gulp.src conf.dependencies
    gulp.src conf.coffee
      .pipe coffee()
    gulp.src conf.templates
      .pipe templateCache(
        module: 'app'
        root: 'src/'
      )
  .pipe concat 'app.js'
  .pipe gulp.dest conf.dist

gulp.task 'default', ['build'], ->
  browserSync.init
    server:
      baseDir: './'
      index: 'index.html'
    notify: false
    online: true
    minify: false
    ghostMode: false
    reloadOnRestart: true
  gulp.watch conf.watch, ['watch']

gulp.task 'watch', ['build'], ->
  watching = true
  browserSync.reload()
