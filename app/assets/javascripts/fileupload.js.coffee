$ ->
  $('.fileupload').each (i, e)->
    $e = $(e)
    callback = $('input[name="callback"]',$e).val()
    $uploading = $('.uploading', $e)
    $progress = $('.progress', $uploading)
    #$progress.hide()
    $bar = $('.progress-bar', $progress)
    $bar.width('50%')
    $('body').prepend($uploading)
    $('input[type="submit"]',$e).hide()
    $('input[type="file"]',$e).fileupload(
      autoUpload: true,
      dataType: 'html',
      headers: { "X-Requested-With": "XMLHttpRequest" }
      start: ()->
      progressall: (e, data)->
        $uploading.show()
        $bar.width("#{parseInt(data.loaded / data.total * 100, 10)}%")
      stop: ()->
        $uploading.hide()
      done: (e, data)->
        $.ajax(
          url: callback
          dataType: 'script',
          data: $.parseJSON(data.result)
        )
    )
