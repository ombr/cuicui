$ ->
  return if window.parent.frames.length > 0
  $preloads = $('.preload')
  if $preloads.length > 0
    $preloads.each (i,e)->
      console.log e
      $iframe = $('<iframe>', src: $(e).attr('href'), style: 'display: none;')
      $iframe.appendTo('body')
