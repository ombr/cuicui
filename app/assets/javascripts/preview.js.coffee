$ ->
  $iframe_preview = $('.iframe-preview')
  $iframe_preview.each (i,e)->
    $e = $(e)
    width = $e.width()
    $iframe = $('iframe', e)
    $iframe.show()
    $drag = $('.content-drag',e)
    ref_width = 1920
    ref_height = 1080
    zoom = width/ref_width
    height = ref_height * zoom

    $content = null
    drag_width = 0
    drag_height = 0
    update_drag_size = ()->
      drag_width = $content.outerWidth()*zoom
      drag_height = $content.outerHeight()*zoom
      console.log drag_width
      $drag.width(drag_width)
      $drag.height(drag_height)
    position_to_css = ($e, pos, size, total, top, bottom)->
      if pos > total - size - pos
        $e.css(bottom, ((total-pos-size)/total*100)+'%')
        $e.css(top, 'auto')
      else
        $e.css(top, (pos/total*100)+'%')
        $e.css(bottom, 'auto')

    $iframe.zoomer(
      width: width
      height: height
      message: ''
      messageURL: '#'
      zoom: zoom

      onComplete: ()->
        $content = $($iframe.contents().find('.image-content'))
        update_drag_size()
        $drag.show()
        $drag.draggable(
          containment: '.iframe-preview'
          drag: (event, ui)->
            #percent = (el, key, pos, size, total)->
              #p = (pos/total*100)
              #el.css(key, (pos/total*100)+'%')
            position_to_css($content, ui.position.top, drag_height, $e.height(), 'top', 'bottom')
            position_to_css($content, ui.position.left, drag_width, $e.width(), 'left', 'right')
              #el.css(key, (pos/total*100)+'%')
            #percent($content, 'top', ui.position.top, width, $e.height())
            #percent($content, 'left', ui.position.left,height, $e.width())
        )
    )
