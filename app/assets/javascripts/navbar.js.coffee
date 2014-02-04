$ ->
  $('body').on 'click', '#nav', ->
    $(this).toggleClass('nav-show')
  $('body').on 'click', (e)->
    if $(e.target).parents('nav').length == 0
      $('#nav').removeClass('nav-show')
  $('#nav').removeClass('nojs')
