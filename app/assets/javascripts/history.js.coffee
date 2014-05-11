$ ->
  $('body').on 'click', 'a.scroll', (e)->
    $e = $(this)
    destination = $e.data('scroll')
    if $(destination).length > 0
      e.preventDefault()
      History.pushState(
        { anchor: destination },
        $e.data('title'), $e.attr('href')
      )
      return false
    true
  History.Adapter.bind window,'statechange',->
    state = History.getState()
    if state.data.anchor
      $destination = $(state.data.anchor)
      if $destination.length > 0
        $(window).scrollTop($destination.position().top)
