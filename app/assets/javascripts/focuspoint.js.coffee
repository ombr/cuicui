$ ->
  $('body').on 'click', '.focuspoint', ->
    $(this).toggleClass('active')
