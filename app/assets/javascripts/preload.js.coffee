$ ->
  $('body').addClass('js')
  number_preload = 3
  callback = ->
    $('.next.preload').each (i,e)->
      $link = $ e
      $link.removeClass('preload')
      $.get($link.attr('href'), {xhr: true}, (data)->
        $image = $($link.parents('.image')[0])
        $data = $(data)
        $image.after($data)
        $link.attr('href', '#' + $(data).attr('id'))
        if number_preload > 0
          number_preload--
          callback()
        #$('body').trigger('loaded')
      , 'html')
    $('.previous.preload').each (i,e)->
      $link = $ e
      target = '#'+$link.data('target-id')
      if $(target).length > 0
        $link.removeClass('preload')
        $link.attr 'href', target

  callback()
  $('body').on('loaded', callback)
  $(window).scroll (e)->
    view = $('body').height()
    if  view - $('body').scrollTop() < 2*view
      callback()
  #return if(window.parent.frames.length > 0)
  #$preloads = $('.preload')
  #if $preloads.length > 0
    #$preloads.each (i,e)->
      #$iframe = $('<iframe>', src: $(e).attr('href'), style: 'display: none;')
      #$iframe.appendTo('body')
