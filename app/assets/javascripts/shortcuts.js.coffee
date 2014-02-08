$ ()->
  go = (destination)->
    $items = $(".#{destination}")
    scroll = $(window).scrollTop()
    console.log "WINDOW ?"
    console.log scroll
    if $items.length > 0
      $items.each (i, e)->
        $e = $(e)
        if $e.offset().top >= scroll
          console.log e
          e.click()
          return false
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
      when 39, 32, 13, 40
        go 'next'
      when 37, 8, 38
        go 'previous'
      when 27
        go 'home'
      else
        console.log event.which
  $('body').on 'click', '.image', (e)->
    if e.target.nodeName == 'IMG'
      window.location = '#' + $(this).attr('id')
