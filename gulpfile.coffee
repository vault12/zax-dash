gulp = require 'gulp'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
browserSync = require('browser-sync').create()
templateCache = require 'gulp-angular-templatecache'
streamqueue = require 'streamqueue'

conf =
  dependencies_css: [
    'node_modules/bootswatch/dist/sandstone/bootstrap.min.css'
  ]
  dependencies_js: [
    'node_modules/js-nacl/lib/nacl_factory.js'
    'node_modules/theglow/dist/theglow.min.js'
    'node_modules/angular/angular.min.js'
  ]
  templates: ['src/**/*.html']
  css: ['src/**/*.css']
  coffee: ['src/**/*.coffee']
  build: 'build/'
  dist: './'
  watch: ['src/**/*.coffee', 'src/**/*.css', '**/*.html']

gulp.task 'css', ->
  streamqueue objectMode: true,
    gulp.src conf.dependencies_css
    gulp.src conf.css
  .pipe concat 'app.css'
  .pipe gulp.dest conf.dist

gulp.task 'js', ->
  streamqueue objectMode: true,
    gulp.src conf.dependencies_js
    gulp.src conf.coffee
      .pipe coffee()
    gulp.src conf.templates
      .pipe templateCache(
        module: 'app'
        root: 'src/'
      )
  .pipe concat 'app.js'
  .pipe gulp.dest conf.dist

gulp.task 'dist', ['css', 'js']

gulp.task 'build', ->
  gulp.src conf.css
  .pipe gulp.dest conf.build

  gulp.src conf.coffee
    .pipe coffee()
  .pipe concat 'app.js'
  .pipe gulp.dest conf.build

gulp.task 'default', ['build'], ->
  browserSync.init
    server:
      baseDir: './'
      index: 'index-dev.html'
    notify: false
    online: true
    minify: false
    ghostMode: false
    reloadOnRestart: true
  gulp.watch conf.watch, ['watch']

gulp.task 'watch', ['build'], ->
  browserSync.reload()
