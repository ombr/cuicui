live_update = (data)->
  $data = $(data)
  $('a.preload',$data).removeClass('preload')
  $destination = $('#' + $data.attr('id'))
  if $destination.length > 0
    $destination.replaceWith($data)

cache = (key, callback, process)->
  return process(key, callback) unless window.localStorage
  cached = window.localStorage.getItem(key)
  callback(cached) if cached != null
  process key, (data)->
    if cached == null
      window.localStorage.setItem(key, data)
      callback(data)
    else
      if cached != data
        window.localStorage.setItem(key, data)
        live_update(data)

get_content = (href, selector, callback)->
  $.get(href, (data)->
    content = $(data).find(selector).parent().html()
    callback(content)
  , 'html')

$ ->
  $window = $(window)
  if window.applicationCache
    $(window.applicationCache).bind 'updateready', ->
      if (window.applicationCache.status == window.applicationCache.UPDATEREADY)
        window.location.reload()
  $window.bind 'storage',(e)->
    live_update e.originalEvent.newValue
  return if window!=window.top
  $document = $(document)
  threshold = $window.height() * 6
  $body = $('body')
  $body.addClass('js')
  preload = ->
    preloaded = $body.prop('scrollHeight') - $window.scrollTop() - $window.height()
    if preloaded < threshold
      $('a.next.preload').each (i,e)->
        $link = $ e
        $link.removeClass('preload').addClass('loading')
        $image = $($link.parents('.image')[0])
        $link.removeClass('preload')
        href = $link.attr('href')
        get_content href, '.preloadable', (new_image)->
          $new_image = $(new_image)
          $link.attr('href', "##{$new_image.attr('id')}")
          $link.parent().after($new_image)
          $link.removeClass('loading').addClass('loaded')
          $new_image.addClass('preloaded')
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

  preload()
  setInterval(preload,250)
