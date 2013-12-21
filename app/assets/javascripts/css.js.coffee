$ ->
  $css = $('[data-css]')
  if $css.length > 0
    $link = $('<link>', {rel:'stylesheet', type:'text/css', 'href': $css.data('css')})
    $link.on('load',()->
        $.cookie('css_loaded','t')
        #alert 'STYLESHEET LOADED WE EAT A COOKIE !!'
      )
    $link.appendTo('head')
