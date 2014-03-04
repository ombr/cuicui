$ ->
  $iframe_preview = $('.iframe-preview')
  if $iframe_preview.length > 0
    width = $iframe_preview.width()
    $iframe = $('iframe', $iframe_preview)
    $iframe.show()
    ref_width = 1920
    ref_height = 1080
    zoom = width/ref_width
    height = ref_height * zoom
    $iframe.zoomer(
      width: width
      height: height
      zoom: zoom
    )
