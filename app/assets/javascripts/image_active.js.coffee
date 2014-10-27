$ ()->
  $items = $('.scrollhistory')
  if $items[0]
    $($items[0]).addClass('active')
  $window = $(window)
  callback = ->
    scroll = $window.scrollTop()
    height = $window.height()
    $('.scrollhistory').each (i, e)->
      $e = $(e)
      if Math.abs($e.offset().top - scroll) < height/3
        return false if $e.hasClass('active')
        $('.scrollhistory').removeClass('active')
        $e.addClass('active')
        History.replaceState({}, $e.data('title'), $e.data('url'))
  didScroll = false
  $(window).scroll ->
    didScroll = true
  setInterval(->
    if didScroll
      didScroll = false
      callback()
  ,250)
