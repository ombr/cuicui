$('.images').fadeOut ->
  $('.images').html('<%= j(render @image) %>')
  $('.images').fadeIn()
