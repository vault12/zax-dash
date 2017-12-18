gulp = require 'gulp'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
gutil = require 'gulp-util'
browserSync = require('browser-sync').create()

process.on 'uncaughtException', (err)->
  if not watching then throw err else gutil.log err.stack || err

conf =
  coffee: [
    '**/*.coffee'
    '*.coffee'
    '!gulpfile.coffee'
    '!node_modules/**/*.coffee'
  ]
  target: './build/'
  watch: [
    '**/*.coffee'
    '**/*.html'
  ]

watching = false

gulp.task 'build', ->
  _coffee = gulp.src conf.coffee
    .pipe coffee().on 'error', (e)->
      _coffee.end()
      if not watching then throw e else gutil.log e.stack || e
    .pipe concat 'app.js'
    .pipe gulp.dest conf.target

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
