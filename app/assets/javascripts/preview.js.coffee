$ ->
  $iframe_preview = $('.iframe-preview')
  $iframe_preview.each (i,e)->
    $e = $(e)
    width = $e.width()
    $iframe = $('iframe', e)
    $iframe.show()
    ref_width = 1920
    ref_height = 1080
    zoom = width/ref_width
    height = ref_height * zoom

    $iframe.zoomer(
      width: width
      height: height
      message: ''
      messageURL: '#'
      zoom: zoom

      onComplete: ()->
        console.log $('.content-drag',e)
        $content = $($iframe.contents().find('.image-content'))
        $drag = $('.content-drag',e)
        $drag.width($content.outerWidth()*zoom)
        $drag.height($content.outerHeight()*zoom)
        $drag.draggable(
          containment: '.iframe-preview'
          start: ()->
            $drag.width($content.outerWidth()*zoom)
            $drag.height($content.outerHeight()*zoom)
          drag: (event, ui)->
            percent = (el, key, pos, total)->
              p = (pos/total*100)
              el.css(key, (pos/total*100)+'%')

            console.log  $(this).offset().top
            percent($content, 'top', ui.position.top, $e.height())
            percent($content, 'left', ui.position.left, $e.width())
        )
    )
