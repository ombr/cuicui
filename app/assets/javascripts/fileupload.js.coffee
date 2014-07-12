$ ->

  $('.fileupload').each (i,form)->
    uploaded = 0
    data_uploaded = 0
    done = 0
    $form = $(form)
    $('input[type=submit]', $form).hide()
    $uploading = $('.uploading', $form)
    $progress = $('.progress', $uploading)
    $bar = $('.progress-bar', $progress)
    $bar.width('0%')
    $input = $('input[type=file]', $form)
    progress= (current)->
      data_uploaded = current if current
      $bar.width("#{Math.max(data_uploaded*0.99, done/uploaded*100)}%")

    $input.attr('multiple', 'true').fileupload(
      dataType: 'xml',
      singleFileUploads: true,
      start: ()->
        $bar.width("0%")
        $uploading.show()
      progressall: (e, data)->
        progress(parseInt((data.loaded / data.total * 100), 10))
      add: (event, file) ->
        uploaded++
        $.getJSON $input.data('new-url'), (data)->
          file.formData = data
          file.submit()
      fail: (event, data)->
        done++
        alert "#{$(data.jqXHR.responseXML).find('Message').text()}"
        progress
      done: (event, data)->
        $.get($input.data('add-url'),
          { key: $(data.result).find('Key').text() },
          ->
            done++
            progress
            if done == uploaded and data.loaded == data.total
              window.location = window.location
        )
    )
  $('.cloudinaryfileupload').each (i, e)->
    $e = $(e)
    callback = $('input[name="callback"]',$e).val()
    $uploading = $('.uploading', $e)
    $progress = $('.progress', $uploading)
    #$progress.hide()
    $bar = $('.progress-bar', $progress)
    $bar.width('0%')
    $('body').prepend($uploading)
    $('input[type="submit"]',$e).hide()
    $('input[type="file"]',$e).fileupload(
      autoUpload: true,
      dataType: 'html',
      headers: { "X-Requested-With": "XMLHttpRequest" }
      start: ()->
        $bar.width("0%")
        $uploading.show()
      progressall: (e, data)->
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
