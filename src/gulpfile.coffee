'use strict'
gulp       = require 'gulp'
getConfig  = require './gulp-task/config'

# ==============================================================================
# タスク読み込み
# ==============================================================================
watchTask = require './gulp-task/watch'
watchTask = require './gulp-task/build'

srcPath   = getConfig('srcPath')
buildPath = getConfig('buildPath')

gulp.task('test',->
	return
)

# # -----------------------------------------------------------------------------
# # 画像圧縮
# # -----------------------------------------------------------------------------
# gulp.task('imgmin',->
#	return gulp.src([
#			dir.img + '/**/*.jpg'
#			dir.img + '/**/*.png'
#			dir.img + '/**/*.svg'
#		])
#		.pipe(imagemin(imagemin))
#		.pipe(gulp.dest(dir.img))
# )