gulp         = require 'gulp'
del          = require 'del'             # ファイルの削除

compass      = require 'gulp-compass'    #
coffee       = require 'gulp-coffee'     #
pleeease     = require 'gulp-pleeease'   # CSS便利ツール
plumber      = require 'gulp-plumber'    # 監視の停止を防ぐ
notify       = require 'gulp-notify'     # 通知
uglify       = require 'gulp-uglify'     # 圧縮
getConfig    = require './config'

srcPath      = getConfig 'srcPath'
buildPath    = getConfig 'buildPath'
useFlg       = getConfig 'useFlg'
compassConf  = getConfig 'compassConf'
uglifyConf   = getConfig 'uglifyConf'
coffeeConf   = getConfig 'coffeeConf'
notifyConf   = getConfig 'notifyConf'
pleeeaseConf = getConfig 'pleeeaseConf'

# ==============================================================================
# タスク
# ==============================================================================
build = ->
	if useFlg.sass
		_compassConf =
			'comments'    : false
			'environment' : 'production'
		for name in _compassConf then compassConf[name] = _compassConf[name]
		_compassConf = compassConf
		_pleeeaseConf =
			minifier : true
		for name in _pleeeaseConf then pleeeaseConf[name] = _pleeeaseConf[name]
		_pleeeaseConf = pleeeaseConf
		# Sass
		_compassConf.sass = srcPath.sass
		gulp
			.src(_compassConf.sass + '/**/*.sass')
			.pipe(compass(_compassConf))
			.on('error',notify.onError(
					title   : 'Sass Build Error'
					message : "<%= error.message %>"
					sound   : notifyConf.sound
			))
			.pipe(pleeease(_pleeeaseConf))
			.pipe(gulp.dest(buildPath.css))
		# Scss
		_compassConf.sass = srcPath.scss
			.src(_compassConf.sass + '/**/*.scss')
			.pipe(compass(_compassConf))
			.on('error',notify.onError(
					title   : 'Sass Build Error'
					message : "<%= error.message %>"
					sound   : notifyConf.sound
			))
			.pipe(pleeease(_pleeeaseConf))
			.pipe(gulp.dest(buildPath.css))
	if useFlg.coffee
		gulp
			.src(srcPath.coffee + '/**/*.coffee')
			.pipe(coffee(coffeeConf).on('error',notify.onError(
				title   : 'CoffeeScript Build Error'
				message : "<%= error.message %>"
				sound   : notifyConf.sound
			)))
			.pipe(uglify(uglifyConf))
			.pipe(gulp.dest(buildPath.js))
	return

# ==============================================================================
# 監視タスク登録
# ==============================================================================
gulp.task 'build',->
	del([
		'./.sass-cache'
	],build)
	return