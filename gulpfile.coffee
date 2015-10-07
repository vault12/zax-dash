gulp = require 'gulp'
watch = require 'gulp-watch'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
concat = require 'gulp-concat'
clean = require 'gulp-clean'
gutil = require 'gulp-util'

process.on 'uncaughtException', (err)->
  if not watching then throw err else gutil.log err.stack || err

conf =
  coffee: [
    '**/*.coffee'
    '*.coffee'
    '!gulpfile.coffee'
    '!node_modules/**/*.coffee'
    '!**/*.js'
  ]
  sass: '**/*.sass'
  target: "./"
  clean: [
    'app.js'
    'styles.css'
  ]
  watch: [
    '**/*.coffee'
    '**/*.sass'
    '**/*.html'
  ]

watching = false

gulp.task 'coffee', ->
  _coffee = gulp.src conf.coffee
    .pipe coffee().on 'error', (e)->
      _coffee.end()
      if not watching then throw e else gutil.log e.stack || e
    .pipe concat 'app.js'
    .pipe gulp.dest conf.target

gulp.task 'sass', ->
  _sass = gulp.src conf.sass
    .pipe sass(
      errLogToConsole: true
      includePaths: conf.sass.include).on 'error', (e)->
      _sass.end()
      if not watching then throw e else gutil.log e.stack || e
    .pipe concat 'styles.css'
    .pipe gulp.dest conf.target

gulp.task 'watch', ['coffee', 'sass'], ->
  watching = true
  watch conf.watch, ->
    gulp.start "build"

gulp.task 'clean', ->
  gulp.src conf.clean, read: false
    .pipe clean()

gulp.task 'build', ['clean', 'coffee', 'sass']
