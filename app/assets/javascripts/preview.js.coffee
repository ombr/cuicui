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
    $background_drag = $('.background-drag',e)
    sizes = $iframe.data('size').split('x')
    ref_width = sizes[0]
    ref_height = sizes[1]
    zoom = width/ref_width
    height = ref_height * zoom

    $content = null
    drag_width = 0
    drag_height = 0


    update_drag_position = (selector, $drag)->
      $el = $iframe.contents().find(selector)
      offset = $el.offset()
      $drag.css('left', "#{offset.left}px")
      $drag.css('top', "#{offset.top}px")
      #$drag.css('border-radius', $el.css('border-radius'))
      $drag.width($el.outerWidth()*zoom)
      $drag.height($el.outerHeight()*zoom)

    position_to_css = (element, pos, size, total, top, bottom)->
      percent_bottom = (total-pos-size)/total*100
      percent_top = pos/total*100
      #if pos > total - size - pos
      if Math.abs(percent_bottom) < Math.abs(percent_top)
        change_css(element, bottom, percent_bottom+'%')
        change_css(element, top, 'auto')
      else
        change_css(element, top, percent_top+'%')
        change_css(element, bottom, 'auto')

    change_css = (element, key, value)->
      regexp = new RegExp("(.*#{key}:)[^;]*(;.*)")
      style = $(element).val()
      if regexp.test(style)
        style = style.replace regexp, "$1#{value}$2"
      else
        style += "#{key}:#{value};"
      $(element).val(style)
    $iframe.zoomer(
      width: width
      height: height
      zoom: zoom
      message: ''
      messageURL: '#'

      onComplete: ()->
        # Firefox body height
        $iframe.contents().find('body').height("#{ref_height}px")
        # $iframe.contents().find('.control').remove()
        # $iframe.contents().find('nav').remove()

        $background_drag.draggable(
          containment: $e,
          stop: ()->
            $('.iframe-preview').each (i,e)=>
              $('iframe', e).trigger('refresh')
          drag: (event, ui)->
            position_to_css('#image_image_css',
                            ui.position.top,
                            $background_drag.height(),
                            $e.height(),
                            'top',
                            'bottom')
            position_to_css('#image_image_css',
                            ui.position.left,
                            $background_drag.width(),
                            $e.width(),
                            'left',
                            'right')
            $('#image_image_css').trigger('change')
         )

        $content = $($iframe.contents().find('.image-content'))
        update_drag_position('.image-content', $drag)
        $drag.show()

        unless $("#image_full").is(':checked')
          update_drag_position('.main-image', $background_drag)
          $background_drag.show()
        $iframe.on 'refresh', ()->
          if $("#image_full").is(':checked')
            $background_drag.hide()
          else
            update_drag_position('.main-image', $background_drag)
            $background_drag.show()
          update_drag_position('.image-content', $drag)
        $drag.resizable(
          handles: 'e, w',
          minWidth: 200 * zoom
          maxWidth: 800 * zoom
          resize: (event, ui)->
            style = $('#image_content_css').val()
            width = ui.size.width / zoom
            change_css('#image_content_css', 'max-width', "#{width}px")
            $('#image_content_css').trigger('change')
            $('.iframe-preview').each (i,e)=>
              $('iframe', e).trigger('refresh')
        ).draggable(
          containment: $e
          stop: ()->
            $('.iframe-preview').each (i,e)=>
              $('iframe', e).trigger('refresh')
          drag: (event, ui)->
            position_to_css('#image_content_css',
                            ui.position.top,
                            $drag.outerHeight(),
                            $e.height(),
                            'top',
                            'bottom')
            position_to_css('#image_content_css',
                            ui.position.left,
                            $drag.outerWidth(),
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
      $('.preview-disabled')
        .show()
        .text('Please reload the page.')
      $('.iframe-preview').hide()
  $('.iframe-preview').each (i,e)->
    reload = true
    iframe_preview(e)


  $('body').on 'click', '.focuspoint .image img', (e)->
    $img = $(this)
    width = $img.width()
    height = $img.height()
    x = e.pageX - $(this).offset().left
    y = e.pageY - $(this).offset().top
    px = (x/width)*100
    py = (y/height)*100
    $('#image_focusx').val(px).trigger('change')
    $('#image_focusy').val(py).trigger('change')

  focus_change = ->
    $('.iframe-preview').each (i,e)=>
      $iframe = $('iframe', e)
      $image = $($iframe.contents().find('.main-image'))
      $('.focuspoint .previews img').each ->
        $(this).css('background-position', "#{$('#image_focusx').val()}% #{$('#image_focusy').val()}%")
      $image.css('background-position', "#{$('#image_focusx').val()}% #{$('#image_focusy').val()}%")

  $('body').on 'change', '#image_focusx', focus_change
  $('body').on 'change', '#image_focusy', focus_change

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
      $('.iframe-preview').each (i,e)=>
        $('iframe', e).trigger('refresh')

  $('body').on 'change', 'input.image-css-position', (e)->
    $('#image_image_css').val(
      $(this).data('style')+"background-position: #{$(this).val()};"
    ).trigger('change')
