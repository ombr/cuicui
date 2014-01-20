if $.cookie('first-control') == 't'
  $('.viewer').removeClass('first-control')

$('body').on 'click', '.viewer', (e)->
  $.cookie('first-control','t', path: '/')
  $(this).removeClass('first-control')
  $(this).toggleClass('show-control')
