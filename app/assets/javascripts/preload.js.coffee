$ ->
  $preloads = $('.preload')
  if $preloads.length > 0
    $preloads.each (i,e)->
      $iframe = $('<iframe>', src: $(e).attr('href'), style: 'display: none;')
      $iframe.appendTo('body')
