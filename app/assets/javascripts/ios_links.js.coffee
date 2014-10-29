if window.navigator.standalone
  $('body').on 'click', 'a', (e)->
    e.preventDefault()
    $a = $(this)
    $a.addClass('disabled').addClass('loading')
    $a.hide()
    $('body').html('')
    $.get $a.attr('href'), (data)->
      regex = /.*<body.*>([\s\S]*)<\/body>.*/
      response = regex.exec(data)[1]
      $('body').html(response)
