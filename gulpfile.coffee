gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
sass    = require 'gulp-sass'
plumber = require 'gulp-plumber'
notify  = require 'gulp-notify'

gulp.task 'compile-coffee', ->
  gulp.src 'src/coffee/**/*.coffee'
    .pipe(plumber(errorHandler: notify.onError('<%= error.message %>')))
    .pipe coffee()
    .pipe gulp.dest('public/js')

gulp.task 'compile-sass', ->
  gulp.src 'src/scss/**/*.scss'
    .pipe(plumber(errorHandler: notify.onError('<%= error.message %>')))
    .pipe sass()
    .pipe gulp.dest('public/css')

gulp.task 'watch', ->
  gulp.watch 'src/coffee/**/*.coffee', ['compile-coffee']
  gulp.watch 'src/scss/**/*.scss', ['compile-sass']

gulp.task 'default', ['compile-coffee', 'compile-sass']
