$ ->
  $window = $(window)
  go = (destination)->
    scroll = $window.scrollTop()
    height = $window.height()
    $items = $("#{destination}")
    click = false
    $items.each (i, e)->
      $e = $(e)
      if Math.abs($e.offset().top - scroll) < height/2
        e.click()
        click = true
        return false
    if not(click) and destination == '.previous'
      $window.scrollTop('0px')
      click = true
    return click
  # $('body').hammer({
  #   swipe: true
  #   swipe_max_touches: 1
  #   swipe_velocity: 0.01
  #   }).on('swiperight',()->
  #     go '.active .previous'
  #   ).on('swipeleft',()->
  #     go '.active .next'
  #   )
  $(document).keydown (event)->
    switch event.which
      when 32, 39, 13, 40
        go '.active .next'
      when 37, 8, 38
        unless go '.active .previous'
          $(window).scrollTop('0px')
      when 27
        go 'home'
    return true
      #else
        # console. log event.which

  delta = 0
  $('body').on 'mousewheel', (event)->
    return if $('body').css('overflow') != 'hidden'
    delta += event.deltaY * event.deltaFactor
    if Math.abs(delta) > 250
      if delta > 0
        go '.previous'
      else
        go '.next'
      delta = 0
