$ ()->
  return
  $rotation = $('.rotation')
  if $rotation.length > 0
    setTimeout(->
      try_click = (selector)->
        $e = $(selector, $rotation)
        if $e.length > 0
          console.log $e[0]
          $e[0].click()
          return false
        true
      try_click('.next') && try_click('.first')
    , 5000)
