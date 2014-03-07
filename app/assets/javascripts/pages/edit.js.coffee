$ ->
  $('body').on('change', '#image_full', ()->
    $(this).parents('form').submit()
  )
