$ ->
  update_iframe_content = ()->
    content = ''
    title = $('#image_title').val()
    if title
      content += '<h1>'+title+'</h1>'
    content += $('.wmd-preview').html()
    $('.iframe-preview').each (e)->
      $iframe = $('iframe', e)
      $content = $($iframe.contents().find('.image-content'))
      return if $content.length == 0
      if content
        $content.show()
        $content.html(content)
      else
        $content.hide()
      $iframe.trigger('refresh')

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
      $legende = $($iframe.contents().find('.image-description'))
      return if $legende.length == 0
      legende = $(this).val()
      if legende
        $legende.show()
        $legende.text(legende)
      else
        $legende.hide()
  $('body').on 'input', '#image_title', ()->
    update_iframe_content()


  iframe_preview=(e)->
    $e = $(e)
    width = $e.width()
    $iframe = $('iframe', e)
    $iframe.show()
    $drag = $('.content-drag',e)
    sizes = $iframe.data('size').split('x')
    ref_width = sizes[0]
    ref_height = sizes[1]
    zoom = width/ref_width
    height = ref_height * zoom

    $content = null
    drag_width = 0
    drag_height = 0


    update_drag_size = ()->
      $drag.attr('style', $('#image_content_css').val())
      drag_width = $content.outerWidth()*zoom
      drag_height = $content.outerHeight()*zoom
      $drag.width(drag_width)
      $drag.height(drag_height)
      $drag.show()
    position_to_css = (pos, size, total, top, bottom)->
      if pos > total - size - pos
        change_css(bottom, ((total-pos-size)/total*100)+'%')
        change_css(top, 'auto')
      else
        change_css(top, (pos/total*100)+'%')
        change_css(bottom, 'auto')

    change_css = (key, value)->
      regexp = new RegExp("(.*#{key}:)[^;]*(;.*)")
      style = $('#image_content_css').val()
      if regexp.test(style)
        style = style.replace regexp, "$1#{value}$2"
      else
        style += "#{key}:#{value};"
      $('#image_content_css').val(style)
    $iframe.zoomer(
      width: width
      height: height
      zoom: zoom
      message: ''
      messageURL: '#'

      onComplete: ()->
        # Firefox body height
        $iframe.contents().find('body').height("#{ref_height}px")
        $iframe.contents().find('.control').remove()
        $iframe.contents().find('nav').remove()
        $content = $($iframe.contents().find('.image-content'))
        update_drag_size()
        $drag.show()
        $iframe.on 'refresh', ()->
          update_drag_size()
        $drag.resizable(
          handles: 'e, w',
          minWidth: 200 * zoom
          maxWidth: 800 * zoom
          resize: (event, ui)->
            style = $('#image_content_css').val()
            width = ui.size.width / zoom
            change_css('max-width', "#{width}px")
            $('#image_content_css').trigger('change')
            $('.iframe-preview').each (i,e)=>
              $('iframe', e).trigger('refresh')
        ).draggable(
          containment: $e
          stop: ()->
            $('.iframe-preview').each (i,e)=>
              $('iframe', e).trigger('refresh')
          drag: (event, ui)->
            position_to_css(ui.position.top,
                            drag_height,
                            $e.height(),
                            'top',
                            'bottom')
            position_to_css(ui.position.left,
                            drag_width,
                            $e.width(),
                            'left',
                            'right')
            $('#image_content_css').trigger('change')
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


  $('body').on 'click', '.focuspoint img', (e)->
    $img = $(this)
    width = $img.width()
    height = $img.height()
    x = e.pageX - $(this).offset().left
    y = e.pageY - $(this).offset().top
    px = (x/width)*100
    py = (y/height)*100
    $('#image_image_css').val(
      "background-position: #{px}% #{py}%;"
    ).trigger('change')

  $('body').on 'change', '#image_image_css', ()->
    $('.iframe-preview').each (i,e)=>
      $iframe = $('iframe', e)
      $image = $($iframe.contents().find('.main-image'))
      style = "background-image: url('#{$image.attr('src')}');" + $(this).val()
      $image.attr('style', style)

  $('body').on 'change', '#image_content_css', ()->
    $('.iframe-preview').each (i,e)=>
      $iframe = $('iframe', e)
      $($iframe.contents().find('.image-content')).attr('style', $(this).val())

  $('body').on 'change', '#image_full', ()->
    $('.iframe-preview').each (i,e)=>
      $iframe = $('iframe', e)
      if $(this).is(':checked')
        $($iframe.contents().find('.image')).addClass('full')
      else
        $($iframe.contents().find('.image')).removeClass('full')

  $('body').on 'change', 'input.image-css-position', (e)->
    $('#image_image_css').val(
      $(this).data('style')+"background-position: #{$(this).val()};"
    ).trigger('change')
