gulp = require 'gulp'
watch = require 'gulp-watch'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
concat = require 'gulp-concat'
clean = require 'gulp-clean'
gutil = require 'gulp-util'
merge = require 'merge-stream'
browserSync = require('browser-sync').create()
useref = require 'gulp-useref'
templateCache = require 'gulp-angular-templatecache'

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
  target: "./dist/"
  clean: [
    './dist/*'
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
  _coffee = gulp.src conf.coffee
    .pipe coffee().on 'error', (e)->
      _coffee.end()
      if not watching then throw e else gutil.log e.stack || e
    .pipe concat 'app.js'
    .pipe gulp.dest conf.target

gulp.task 'useref', ->
  gulp.src('*.html')
  .pipe useref()
  .pipe gulp.dest(conf.target)

gulp.task 'templates', ->
  gulp.src('**/*.template.html')
    .pipe(templateCache(module: 'app'))
    .pipe gulp.dest(conf.target)


gulp.task 'default', ['build'], ->
  browserSync.init
    server:
      baseDir: '.'
      index: 'dist/index.html'
    notify: false
    online: true
    minify: false
    ghostMode: false
    reloadOnRestart: true
  gulp.watch conf.watch, ['watch']

gulp.task 'watch', ['coffee'], ->
  watching = true
  watch conf.watch, ->
    gulp.start "build"

gulp.task 'clean', ->
  gulp.src conf.clean, read: false
    .pipe clean()

gulp.task 'build', ['clean','templates','useref','coffee']
