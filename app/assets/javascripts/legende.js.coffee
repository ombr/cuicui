$ ()->
  place_description = (image)->
    $img = $('img', image)
    if $img.height() == 0
      $img.on 'load', ()->
        place_description image
        return
    $description = $('.image-description', image)
    $description.css('position', 'absolute')
    $description.css('width', '100%')
    $description.css('top',  parseInt($img.css('margin-top')) + $img.height()+ 'px') 

  $(window).resize ()->
    $('.image.description-loaded').each (i,e)->
      setTimeout(()->
        place_description(e)
      ,0)

  $('body').on('loaded', ()->
    $('.image:not(.description-loaded)').each (i,e)->
      $e = $(e)
      $e.addClass('description-loaded')
      place_description($e)
  )

