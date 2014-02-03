$ ->
  $('body').on 'click', '#nav', ->
    $(this).toggleClass('nav-collapse')
  $('body').on 'click', (e)->
    console.log 'remove ?'
    console.log $(e.target).parents('#nav').length
    if $(e.target).parents('nav').length == 0
      console.log 'REMOVE !!'
      $('#nav').addClass('nav-collapse')
  $('#nav').addClass('nav-collapse')
  $('#nav').removeClass('nojs')
#$(window).on 'page:change', ->
  #$('#nav-content').addClass('collapse')
