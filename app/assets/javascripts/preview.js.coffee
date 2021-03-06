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
    $('.iframe-preview').each (i,e)=>
      $iframe = $(e).find('iframe')
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


  iframe_preview=(e, callback)->
    $e = $(e)
    width = $e.width()
    $iframe = $e.find('iframe')
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
      $drag.width($el.outerWidth()*zoom)
      $drag.height($el.outerHeight()*zoom)

    position_to_css = (element, pos, size, total, top, bottom)->
      percent_bottom = (total-pos-size)/total*100
      percent_top = pos/total*100
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
      $(element).trigger('change')
    $iframe.zoomer(
      width: width
      height: height
      zoom: zoom
      message: ''
      messageURL: '#'

      onComplete: ()->
        # Firefox body height
        $iframe.contents().find('body').height("#{ref_height}px")
        $iframe.contents().find('.next').remove()
        $iframe.contents().find('.previous').remove()
        #$iframe.contents().find('#home').remove()

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

        $iframe.on 'refresh', ()->
          if $("#image_full").is(':checked')
            $background_drag.hide()
          else
            update_drag_position('.image', $background_drag)
            $background_drag.show()
          update_drag_position('.image-content', $drag)
        $iframe.trigger 'refresh'
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
        callback()
    )

  reload = false
  width = $(window).width()
  $(window).resize ()->
    if reload and width != $(window).width()
      $('.preview-disabled')
        .show()
        .text('Please reload the page.')
      $('.iframe-preview').hide()
  reload = true
  async.eachSeries($('.iframe-preview'),iframe_preview)

  focus_change = ->
    px = $('#image_focusx').val() || 50
    py = $('#image_focusy').val() || 50
    $('.iframe-preview').each (i,e)=>
      $iframe = $('iframe', e)
      $image = $($iframe.contents().find('.image'))
      $image.css('background-position', "#{px}% #{py}%")
    $('#focuspoint .previews img').each ->
      $(this).css('background-position', "#{px}% #{py}%")
    $('#focuspoint .pointer').css('top', "#{py}%").css('left', "#{px}%")

  $('body').on 'change', '#image_focusx', focus_change
  $('body').on 'change', '#image_focusy', focus_change

  $('body').on 'change', '#image_image_css', ()->
    $('.iframe-preview').each (i,e)=>
      $iframe = $('iframe', e)
      $image = $($iframe.contents().find('.image'))
      style = "background-image: url('#{$image.attr('src')}');" + $(this).val()
      $image.attr('style', style)
  $('body').on 'change', '#image_content_css', ()->
    $('.iframe-preview').each (i,e)=>
      $iframe = $(e).find('iframe')
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
