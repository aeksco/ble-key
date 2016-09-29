# TODO - abstract into aeksco/gulp_tasks
module.exports = (gulp, paths, plugins) ->

  # Concat Task
  gulp.task 'concat', ->
    stream = gulp.src(paths.concat.src)
      .pipe plugins.plumber()
      .pipe plugins.concat(paths.concat.dest)

    stream.pipe uglify() if process.env.NODE_ENV == 'prod'
    stream.pipe gulp.dest paths.dest + 'js/'

  # Bundle task
  gulp.task 'bundle', ->
    stream = gulp.src(paths.src + paths.bundle.src, { read: false })
      .pipe plugins.plumber()
      .pipe plugins.browserify
        debug:      if process.env.NODE_ENV == 'prod' then 'production' else 'development'
        debug:      true
        transform:  ['coffeeify', 'jadeify']
        extensions: ['.coffee', '.jade']
      .pipe plugins.concat(paths.bundle.dest)

    stream.pipe uglify() if process.env.NODE_ENV == 'prod'
    stream.pipe gulp.dest paths.dest + 'js/'

  # Compiles NodeWebKit package.json manifest
  gulp.task 'manifest', ->

    writeManifest = ->
      manifest = require('./app/manifest.coffee')
      plugins.fs.writeFile( paths.dest + paths.manifest.dest, manifest )
      # plugins.fs.writeFile(paths.manifest.dest, manifest)

    plugins.fs.exists paths.dest, (exists) ->
      if exists
        writeManifest()
      else
        plugins.fs.mkdir paths.dest, -> writeManifest()

# # # # #
