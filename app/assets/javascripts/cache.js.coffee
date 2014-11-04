$ ->
  if window.applicationCache
    $(window.applicationCache).bind 'updateready', ->
      if (window.applicationCache.status == window.applicationCache.UPDATEREADY)
        $('.cache-update').show()

  $('body').on 'click', '.cache-update', (e)->
    e.preventDefault()
    window.location.reload()
