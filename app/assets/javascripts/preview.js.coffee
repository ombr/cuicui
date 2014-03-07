$ ->
  iframe_preview=(e)->
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
      $drag.width(drag_width)
      $drag.height(drag_height)
    position_to_css = (pos, size, total, top, bottom)->
      if pos > total - size - pos
        "#{bottom}: #{((total-pos-size)/total*100)+'%'};#{top}: auto;"
        #$e.css(top, 'auto')
      else
        "#{top}: #{(pos/total*100)+'%'};#{bottom}: auto;"
        #$e.css(bottom, 'auto')

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
            style = position_to_css(ui.position.top, drag_height, $e.height(), 'top', 'bottom')
            style += position_to_css(ui.position.left, drag_width, $e.width(), 'left', 'right')
            $content.attr('style', style)
            $('#image_content_css').val(style)
        )
    )
  $('.iframe-preview').each (i,e)->
    $(window).resize ()->
      window.location = window.location
    iframe_preview(e)
