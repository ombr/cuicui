get_image = ($link, callback)->
  $link.removeClass('preload')
  $.get($link.attr('href'), (data)->
    $image = $(data).find('.image')
    callback($image)
  , 'html')

$ ->
  $window = $(window)
  $document = $(document)
  threshold = $window.height() * 6
  $body = $('body')
  return if window!=window.top
  $('body').addClass('js')
  preload = ->
    preloaded = $body.prop('scrollHeight') - $window.scrollTop() - $window.height()
    if preloaded < threshold
      $('.next.preload').each (i,e)->
        $link = $ e
        $image = $($link.parents('.image')[0])
        get_image $link, ($new_image)->
          # $('.preload.previous', $new_image).removeClass('preload')
          $image.after($new_image)
          preload()

    # This is a bad idea...
    # if $window.scrollTop() < threshold and $body.prop('scrollHeight') > 2*$window.height()
    #   $('.previous.preload').each (i,e)->
    #     $link = $ e
    #     $image = $($link.parents('.image')[0])
    #     get_image $link, ($new_image)->
    #       $('.preload.next', $new_image).removeClass('preload')
    #       before_insert = $image.position().top
    #       old_height = $(document).height()
    #       old_scroll = $window.scrollTop()
    #       $new_image = $image.before($new_image)
    #       $new_image.css('height: 200px')
    #       $document.scrollTop(old_scroll + $document.height() - old_height)
    #       preload()
    # $('.previous.preload').each (i,e)->
    #   $link = $ e
    #   target = '#'+$link.data('target-id')
    #   if $(target).length > 0
    #     $link.removeClass('preload')
    #     $link.attr 'href', target

  preload()
  #$('body').on('loaded', preload)
  timeout = null
  $window.scroll ->
    clearTimeout(timeout)
    timeout = setTimeout preload, 500
