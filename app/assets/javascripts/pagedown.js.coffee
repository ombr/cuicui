$ ->
  if $('.wmd-panel').length > 0
    converter1 = Markdown.getSanitizingConverter()
    editor1 = new Markdown.Editor(converter1)
    editor1.run()
