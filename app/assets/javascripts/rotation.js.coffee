$ ()->
  return if window.parent.frames.length > 0
  $rotation = $('.rotation')
  if $rotation.length > 0
    setInterval(->
      try_click = (selector)->
        $e = $(selector, $rotation)
        if $e.length > 0
          $.ajax(
            url: $e.attr('href') + '.js',
            dataType: "script",
            cache: true,
          )
          return false
        true
      try_click('.next') && try_click('.first')
    , 7000)
