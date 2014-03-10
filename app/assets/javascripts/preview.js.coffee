$ ->
  update_iframe_content = ()->
    content = '<h1>'+$('#image_title').val()+'</h1>'+$('.wmd-preview').html()
    $('.iframe-preview').each (e)->
      $iframe = $('iframe', e)
      $content = $($iframe.contents().find('.image-content'))
      if $content.length == 0
        $image = $($iframe.contents().find('.image'))
        if $image.length > 0
          $iframe.contents().find('body').html('<h1>Update the image to get the preview.</h1>')
        else
          return
      $content.html(content)
      $('.content-drag',e).trigger('refresh')

  if $('.wmd-panel').length > 0
    converter1 = Markdown.getSanitizingConverter()
    editor1 = new Markdown.Editor(converter1)
    editor1.run()
    editor1.hooks.chain("onPreviewRefresh", ()->
      update_iframe_content()
    )

  $('body').on 'input', '#image_legend', ()->
    $('.iframe-preview').each (e)=>
      $iframe = $('iframe', e)
      $description = $($iframe.contents().find('.image-description'))
      if $description.length > 0
        $($iframe.contents().find('.image-description')).text($(this).val())
      else
        $iframe.contents().find('body').html('<h1>Update the image to get the preview.</h1>')
  $('body').on 'input', '#image_title', ()->
    update_iframe_content()


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
        $iframe.contents().find('.control').remove()
        $iframe.contents().find('nav').remove()
        $content = $($iframe.contents().find('.image-content'))
        update_drag_size()
        $drag.show()
        $drag.on 'refresh', ()->
          update_drag_size()
        $drag.draggable(
          containment: '.iframe-preview'
          drag: (event, ui)->
            style = position_to_css(ui.position.top, drag_height, $e.height(), 'top', 'bottom')
            style += position_to_css(ui.position.left, drag_width, $e.width(), 'left', 'right')
            $content.attr('style', style)
            $('#image_content_css').trigger('change')
            $('#image_content_css').val(style)
        )
    )

  reload = false
  width = $(window).width()
  $(window).resize ()->
    if reload and width != $(window).width()
      window.location = window.location
  $('.iframe-preview').each (i,e)->
    reload = true
    iframe_preview(e)

  $('body').on('change', '#image_full', ()->
    $('.iframe-preview').each (i,e)=>
      $iframe = $('iframe', e)
      if $(this).val() == 'true'
        $($iframe.contents().find('.image')).addClass('full')
      else
        $($iframe.contents().find('.image')).removeClass('full')
  )
