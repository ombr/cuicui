$ ->
  $body = $ 'body'
  if window.applicationCache
    $(window.applicationCache).bind 'updateready', ->
      if (window.applicationCache.status == window.applicationCache.UPDATEREADY)
        $('.cache-update').show()
    $(window.applicationCache).bind 'obsolete', ->
      window.location.reload()
    $(window.applicationCache).bind 'noupdate', ->
      $body.addClass 'appcache-cached'
    $(window.applicationCache).bind 'cached', ->
      $body.addClass 'appcache-cached'
    $(window.applicationCache).bind 'error', (e)->
      if $('.offline-error').length > 0
        $('.offline-error').html(e.originalEvent.message)

  $body.on 'click', '.offline-cancel-btn', (e)->
    $.removeCookie('offline', path: '/')
    window.location.reload()
  $body.on 'click', '.offline-btn', (e)->
    $.cookie('offline', 'true', { path: '/', expires: 365 })
    window.location.reload()
  $body.on 'click', '.cache-update', (e)->
    e.preventDefault()
    window.location.reload()
  appCache = window.applicationCache
