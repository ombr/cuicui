$ ->
  $('.fileupload').each (i, e)->
    $e = $(e)
    callback = $('input[name="callback"]',$e).val()
    $progress = $('<div class="progress"><div class="progress-bar"></div></div>')
    $progress.hide()
    $bar = $('.progress-bar', $progress)
    $e.prepend($progress)
    $('input[type="submit"]',$e).hide()
    $('input[type="file"]',$e).fileupload(
      autoUpload: true,
      dataType: 'html',
      headers: { "X-Requested-With": "XMLHttpRequest" }
      progressall: (e, data)->
        $progress.show()
        $bar.width("#{parseInt(data.loaded / data.total * 100, 10)}%")
      done: (e, data)->
        if data.loaded == data.total
          $progress.hide()
        $.ajax(
          url: callback
          dataType: 'script',
          data: $.parseJSON(data.result)
        )
    )
