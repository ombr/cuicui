$ ()->
  go = (destination)->
    $items = $("#{destination}")
    scroll = $(window).scrollTop()
    click = false
    if $items.length > 0
      $items.each (i, e)->
        $e = $(e)
        if $e.offset().top >= scroll
          e.click()
          click = true
          return false
    return click
  Hammer(document.body,{
    swipe: true
    swipe_max_touches: 1
    swipe_velocity: 0.01
    }).on('swiperight',()->
      go 'previous'
    ).on('swipeleft',()->
      go 'next'
    )

  $(document).keydown (event)->
    switch event.which
      when 32, 39, 13
        go '.active .next'
      when 37, 8
        unless go '.active .previous'
          $(window).scrollTop('0px')
      when 27
        go 'home'
    return true
      #else
        #console.log event.which
  $('body').on 'click', '.image', (e)->
    if e.target.nodeName == 'IMG'
      window.location = '#' + $(this).attr('id')
