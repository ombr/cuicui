$ ()->
  $images = $('.image')
  if $images[0]
    $($images[0]).addClass('active')
  $window = $(window)
  callback = ->
    scroll = $window.scrollTop()
    height = $window.height()
    $('.image').each (i, e)->
      $e = $(e)
      if Math.abs($e.offset().top - scroll) < height/3
        return false if $e.hasClass('active')
        $('.image').removeClass('active')
        $e.addClass('active')
        History.replaceState({}, $e.data('title'), $e.data('url'))
  setInterval callback, 500
