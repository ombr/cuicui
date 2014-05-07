get_image = ($link, callback)->
  $link.removeClass('preload')
  $.get($link.attr('href'), (data)->
    $image = $(data).find('.image')
    callback($image)
  , 'html')

$ ->
  $window = $(window)
  $document = $(document)
  threshold = $window.height() * 3
  $body = $('body')
  return if window!=window.top
  $('body').addClass('js')
  preload = ->
    preloaded = $body.prop('scrollHeight') - $window.scrollTop() - $window.height()
    if preloaded < threshold
      $('.next.preload').each (i,e)->
        $link = $ e
        $image = $($link.parents('.image')[0])
        get_image $link, ($new_image)->
          # $('.preload.previous', $new_image).removeClass('preload')
          $image.after($new_image)
          preload()

    # This is a bad idea...
    # if $window.scrollTop() < threshold and $body.prop('scrollHeight') > 2*$window.height()
    #   $('.previous.preload').each (i,e)->
    #     $link = $ e
    #     $image = $($link.parents('.image')[0])
    #     get_image $link, ($new_image)->
    #       $('.preload.next', $new_image).removeClass('preload')
    #       before_insert = $image.position().top
    #       old_height = $(document).height()
    #       old_scroll = $window.scrollTop()
    #       $new_image = $image.before($new_image)
    #       $new_image.css('height: 200px')
    #       $document.scrollTop(old_scroll + $document.height() - old_height)
    #       preload()
    # $('.previous.preload').each (i,e)->
    #   $link = $ e
    #   target = '#'+$link.data('target-id')
    #   if $(target).length > 0
    #     $link.removeClass('preload')
    #     $link.attr 'href', target

  preload()
  #$('body').on('loaded', preload)
  $window.scroll (e)->
    preload()

  $('body').on 'click', 'a.scroll', (e)->
    $e = $(this)
    destination = $e.data('scroll')
    if $(destination).length > 0
      e.preventDefault()
      History.pushState(
        { anchor: destination },
        $e.data('title'), $e.attr('href')
      )
      return false
    true
  History.Adapter.bind window,'statechange',->
    state = History.getState()
    if state.data.anchor
      $destination = $(state.data.anchor)
      if $destination.length > 0
        $(window).scrollTop($destination.position().top)



  #animation = false
  #$destination = null


  #closer = (from, to, step)->
    #if Math.abs(from-to) < step
      #return to
    #else
      #if from < to
        #return from+step
      #else
        #return from-step
  #next_step = null
  #auto_scroll = ()->
    #scroll = $window.scrollTop()
    #height = $window.height()
    #$('.image').each (i, e)->
      #$e = $(e)
      #if Math.abs($e.offset().top - scroll) < height/2
        #return false if $e.hasClass('active')
        #setTimeout(()->
          #animation = false
        #,0)
        #animation = true
        #$e.addClass('active')
        #$destination = $e
        #next_step = Math.round(scroll-1)
        #$('body').scrollTop(next_step)
        #animation = false
        #$('body').animate(
          #scrollTop: $e.offset().top
        #,700, 'swing', ()->
          #setTimeout(()->
            #$('.image').removeClass('active')
            #$e.addClass('active')
            #animation = false
          #,0)
        #)
        #return false

  #timeout = null
  #enable_timeout = (callback)->
    #if timeout
      #clearTimeout(timeout)
    #timeout = setTimeout(callback, 400)

  #$window.resize ()->
    #enable_timeout ()->
      #$images = $('.image.active')
      #if $images.length > 0
        #$('body').scrollTop($($images[0]).offset().top)

  #$window.scroll ()->
    #if $destination != null
      #dest_top = $destination.offset().top
      #top = $window.scrollTop()
      #if Math.abs(next_step - top) > 5
        #$destination = null
      #next_step = closer(top, dest_top, 5)
      #if next_step == dest_top
        #$destination = null
      #setTimeout(()->
        #$('body').scrollTop(next_step)
      #,10)
    #else
      #enable_timeout auto_scroll
  #return if(window.parent.frames.length > 0)
  #$preloads = $('.preload')
  #if $preloads.length > 0
    #$preloads.each (i,e)->
      #$iframe = $('<iframe>', src: $(e).attr('href'), style: 'display: none;')
      #$iframe.appendTo('body')
