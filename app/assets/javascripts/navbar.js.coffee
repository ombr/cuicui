$ ->
  $document = $(document)
  setInterval(->
    if $document.width() / window.innerWidth > 1.2
      $('#home').hide()
    else
      $('#home').show()
  ,500)
