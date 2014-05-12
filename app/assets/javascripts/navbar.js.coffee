$ ->
  $('body').on 'click', '#nav', (e)->
    $(this).toggleClass('nav-show')
    if $(e.target).hasClass('menu')
      e.preventDefault()
      return false
  $('body').on 'click', (e)->
    if $(e.target).parents('nav').length == 0
      $('#nav').removeClass('nav-show')
  $('#nav').removeClass('nojs')
