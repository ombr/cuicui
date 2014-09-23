$ ->
  $window = $ window
  $body = $ 'body'
  $window.on 'scroll.watcher', ->
    $window.unbind('scroll.watcher')
    $body.addClass('scrolled')
  $body.on 'click', '.help-scroll-icon', ->
    $('html, body').animate({
      scrollTop: $window.height()+51
    }, 1000)
