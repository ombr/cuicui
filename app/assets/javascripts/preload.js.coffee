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
        $link.hide()
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
        $link.hide()

  callback()
  $('body').on('loaded', callback)
  $(window).scroll (e)->
    view = $('body').height()
    if  view - $('body').scrollTop() < 2*view
      callback()



  animation = false
  $window = $(window)

  # Init :
  $images = $('.image')
  if $images[0]
    $($images[0]).addClass('active')
  # Auto scroll :
  auto_scroll = ()->
    scroll = $window.scrollTop()
    height = $window.height()
    console.log "2 - OK"
    $('.image').each (i, e)->
      $e = $(e)
      console.log Math.abs($e.offset().top - scroll)
      if Math.abs($e.offset().top - scroll) < height/2
        return false if $e.hasClass('active')
        #setTimeout(()->
          #console.log '4 - END ANNIMATION !'
          #animation = false
        #,0)
        animation = true
        console.log "3 - ANIM START !"
        #$('body').scrollTop($e.offset().top)
        #$e.addClass('active')
        #animation = false
        $('body').animate(
          scrollTop: $e.offset().top
        ,700, 'swing', ()->
          setTimeout(()->
            $('.image').removeClass('active')
            $e.addClass('active')
            console.log '4 - END ANNIMATION !'
            animation = false
          ,0)
        )
        return false

  timeout = null
  enable_timeout = (callback)->
    unless animation
      if timeout
        clearTimeout(timeout)
      timeout = setTimeout(callback, 200)

  $window.resize ()->
    enable_timeout ()->
      $images = $('.image.active')
      if $images.length > 0
        $('body').scrollTop($($images[0]).offset().top)

  $window.scroll ()->
    enable_timeout auto_scroll
  #return if(window.parent.frames.length > 0)
  #$preloads = $('.preload')
  #if $preloads.length > 0
    #$preloads.each (i,e)->
      #$iframe = $('<iframe>', src: $(e).attr('href'), style: 'display: none;')
      #$iframe.appendTo('body')
