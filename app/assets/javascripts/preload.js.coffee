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
        $('body').trigger('loaded')
      , 'html')
    $('.previous.preload').each (i,e)->
      $link = $ e
      target = '#'+$link.data('target-id')
      if $(target).length > 0
        $link.removeClass('preload')
        $link.attr 'href', target

  callback()
  #$('body').on('loaded', callback)
  $window = $(window)
  $window.scroll (e)->
    if $('body').prop('scrollHeight') - $window.scrollTop() < 6 * $window.height()
      callback()




  #animation = false
  #$destination = null


  #closer = (from, to, step)->
    #console.log "#{from} -> #{to} (#{step})"
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
          #console.log '4 - END ANNIMATION !'
          #animation = false
        #,0)
        #animation = true
        #$e.addClass('active')
        #$destination = $e
        #console.log "3 - ANIM START !"
        #next_step = Math.round(scroll-1)
        #console.log next_step
        #$('body').scrollTop(next_step)
        #animation = false
        #$('body').animate(
          #scrollTop: $e.offset().top
        #,700, 'swing', ()->
          #setTimeout(()->
            #$('.image').removeClass('active')
            #$e.addClass('active')
            #console.log '4 - END ANNIMATION !'
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
      #console.log "MOVE ??"
      #console.log top
      #console.log next_step
      #if Math.abs(next_step - top) > 5
        #console.log 'STOP ??'
        #$destination = null
        #console.log "ERROR MOVE ?"
      #next_step = closer(top, dest_top, 5)
      #console.log "MOVE TO : #{next_step}"
      #if next_step == dest_top
        #console.log 'STOP !!'
        #$destination = null
      #setTimeout(()->
        #console.log "WE MOVE :-D#{next_step}"
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
