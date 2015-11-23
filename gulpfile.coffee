gulp = require 'gulp'
watch = require 'gulp-watch'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
concat = require 'gulp-concat'
clean = require 'gulp-clean'
gutil = require 'gulp-util'
merge = require 'merge-stream'
browserSync = require('browser-sync').create()


process.on 'uncaughtException', (err)->
  if not watching then throw err else gutil.log err.stack || err

conf =
  coffee: [
    '**/*.coffee'
    '*.coffee'
    '!gulpfile.coffee'
    '!lib/glow/**'
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
    '!lib/glow/**'
    '**/*.coffee'
    '**/*.sass'
    '**/*.html'
  ]

watching = false

gulp.task 'coffee', ->
  libs = gulp.src ['lib/glow/dist/theglow.min.js']
  _coffee = gulp.src conf.coffee
    .pipe coffee().on 'error', (e)->
      _coffee.end()
      if not watching then throw e else gutil.log e.stack || e
  merge(libs,_coffee)
    .pipe concat 'app.js'
    .pipe gulp.dest conf.target

gulp.task 'dist', ->
  true

gulp.task 'default', ['build'], ->
  browserSync.init
    server:
      baseDir: '.'
      index: 'index.html'
    notify: false
    online: true
    minify: false
    reloadOnRestart: true
  gulp.watch conf.watch, ['watch']

gulp.task 'watch', ['coffee'], ->
  watching = true
  watch conf.watch, ->
    gulp.start "build"

gulp.task 'clean', ->
  gulp.src conf.clean, read: false
    .pipe clean()

gulp.task 'build', ['clean', 'coffee']
