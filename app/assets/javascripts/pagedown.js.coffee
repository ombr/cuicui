$ ->
  if $('.wmd-panel').length > 0
    converter1 = Markdown.getSanitizingConverter()
    editor1 = new Markdown.Editor(converter1)
    editor1.run()
    editor1.hooks.chain("onPreviewRefresh", ()->
      content = $('.wmd-preview').html()
      $('.iframe-preview').each (e)->
        $content = $($('iframe', e).contents().find('.image-content'))
        #if content != ''
        if $content.length > 0
          $content.html(content)
    )
