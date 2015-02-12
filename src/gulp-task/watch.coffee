gulp         = require 'gulp'
compass      = require 'gulp-compass'    #
coffee       = require 'gulp-coffee'     #
pleeease     = require 'gulp-pleeease'   # CSS便利ツール
plumber      = require 'gulp-plumber'    # 監視の停止を防ぐ
notify       = require 'gulp-notify'     # 通知
changed      = require 'gulp-changed'    # 変更されたファイルだけストリームに出す
cached       = require 'gulp-cached'     # キャッシュ
sourcemaps   = require 'gulp-sourcemaps' # ソースマップ出力
getConfig    = require './config'

srcPath      = getConfig 'srcPath'
buildPath    = getConfig 'buildPath'
useFlg       = getConfig 'useFlg'
compassConf  = getConfig 'compassConf'
pleeeaseConf = getConfig 'pleeeaseConf'
coffeeConf   = getConfig 'coffeeConf'
notifyConf   = getConfig 'notifyConf'

# ==============================================================================
# タスク
# ==============================================================================
# Sass
# ------------------------------------------------------------------------------
sassBuild = (e,type)->
	# Compassの設定
	_compassConf =
		'comments'    : true
		'environment' : 'development'
	for name in _compassConf then compassConf[name] = _compassConf[name]
	_compassConf = compassConf
	# pleeaseの設定
	_pleeeaseConf =
		minifier : false
	for name in _pleeeaseConf then pleeeaseConf[name] = _pleeeaseConf[name]
	_pleeeaseConf = pleeeaseConf
	# --------------------------------------------------------------------------
	switch type
		when 'sass'
			_compassConf.sass = srcPath.sass
			gulp
				.src(_compassConf.sass + '**/*.sass')
				.pipe(changed(buildPath.css))
				.pipe(plumber({errorHandler : notify.onError(
					title   : 'Sass Build Error'
					message : '<%= error.message %>'
					sound   : notifyConf.sound
				)}))
				.pipe(compass(_compassConf))
				.pipe(pleeease(_pleeeaseConf))
				.pipe(gulp.dest(buildPath.css))
		when 'scss'
			_compassConf.sass = srcPath.scss
			gulp
				.src(_compassConf.sass + '**/*.scss')
				.pipe(changed(buildPath.css))
				.pipe(plumber({errorHandler : notify.onError(
					title   : 'Sass Build Error'
					message : '<%= error.message %>'
					sound   : notifyConf.sound
				)}))
				.pipe(compass(_compassConf))
				.pipe(pleeease(_pleeeaseConf))
				.pipe(gulp.dest(buildPath.css))
	return
# ------------------------------------------------------------------------------
# Coffee
# ------------------------------------------------------------------------------
coffeeBuild = (e)->
	coffeeStream = coffee(coffeeConf)
	error        = false
	coffeeStream.on('error',(e)->
		error = true
		return
	)
	gulp
		.src(srcPath.coffee + '**/*.coffee')
		.pipe(cached('coffee'))
		.pipe(plumber({errorHandler : notify.onError(
			title   : 'CoffeeScript Build Error'
			message : '<%= error.message %>'
			sound   : notifyConf.sound
		)}))
		.pipe(sourcemaps.init())
		.pipe(coffeeStream)
		.pipe(sourcemaps.write())
		.pipe(gulp.dest(buildPath.js))
		.on('end',->
			if !error
				_path     = e.path.split('/')
				_filename = _path.pop()
				console.log _filename + ' was ' + e.type + '.'
			return
		)
	return

# ==============================================================================
# 監視タスク登録
# ==============================================================================
gulp.task 'watch',->
	if useFlg.sass
		gulp.watch srcPath.sass+'/**/*.sass',(e)->
			sassBuild e,'sass'
			return
		gulp.watch srcPath.scss+'/**/*.scss',(e)->
			sassBuild e,'scss'
			return
	if useFlg.coffee
		gulp.watch srcPath.coffee+'/**/*.coffee',(e)->
			coffeeBuild e
			return
	return