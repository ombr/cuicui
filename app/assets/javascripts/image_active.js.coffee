$ ()->
  $images = $('.image')
  if $images[0]
    $($images[0]).addClass('active')
  $window = $(window)
  $window.scroll (e)->
    scroll = $window.scrollTop()
    height = $window.height()
    $('.image').each (i, e)->
      $e = $(e)
      if Math.abs($e.offset().top - scroll) < height/2
        return false if $e.hasClass('active')
        $('.image').removeClass('active')
        $e.addClass('active')
