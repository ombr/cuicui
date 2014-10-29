$ ->
  $window = $ window
  $body = $ 'body'
  callback = ->
    $window.unbind('scroll.watcher', callback)
    $body.addClass('scrolled')
  $window.on 'scroll.watcher', callback
  $body.on 'click', '.help-scroll-icon', ->
    $('html, body').animate({
      scrollTop: $window.height()+51
    }, 1000)
