gulp = require 'gulp'
watch = require 'gulp-watch'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
concat = require 'gulp-concat'
del = require 'del'
gutil = require 'gulp-util'
merge = require 'merge-stream'
browserSync = require('browser-sync').create()
useref = require 'gulp-useref'
sourcemaps  = require 'gulp-sourcemaps'
templateCache = require 'gulp-angular-templatecache'
vinyl = require 'vinyl-paths'

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
    'dist/*'
    'app.js'
    'styles.css'
  ]
  watch: [
    '!lib/glow/**'
    '**/*.coffee'
    '**/*.sass'
    '**/*.html'
  ]
  copy: [
    'node_modules/theglow/lib/theglow.js'
    'node_modules/theglow/lib/theglow.js.map'
    'node_modules/js-nacl/lib/nacl_factory.js'
  ]

watching = false

gulp.task 'coffee', ->
  _coffee = gulp.src conf.coffee
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe coffee().on 'error', (e)->
      _coffee.end()
      if not watching then throw e else gutil.log e.stack || e
    .pipe concat 'app.js'
    .pipe(sourcemaps.write('./'))
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
      baseDir: './dist/'
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

gulp.task 'copy', ->
  gulp.src conf.copy
  .pipe gulp.dest(conf.target)

gulp.task 'clean', ->
  gulp.src conf.clean
    .pipe vinyl del

gulp.task 'build', ['clean','templates','useref', 'copy','coffee']
