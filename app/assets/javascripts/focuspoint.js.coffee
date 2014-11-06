$ ->
  focuspoint_position = ($img, e)->
    width = $img.width()
    height = $img.height()
    x = e.pageX - $img.offset().left
    y = e.pageY - $img.offset().top
    px = (x/width)*100
    py = (y/height)*100
    [px, py]
  $('body').on 'click', '#focuspoint .selector', (e)->
    $img = $ this
    [px, py] = focuspoint_position($img, e)
    $('#image_focusx').val(px)
    $('#image_focusy').val(py)
    $('#image_focusy').trigger('change')
  $focuspoint = $('#focuspoint')
  if $focuspoint.length
    $selector = $('.selector', $focuspoint)
    $pointer = $('.pointer', $focuspoint)
    $pointer.draggable(
      containment: $selector,
      start: ()->
        $focuspoint.addClass('drag')
      stop: ()->
        $focuspoint.removeClass('drag')
      drag: (event, ui)->
        py = ui.position.top/$selector.height()*100
        px = ui.position.left/$selector.width()*100
        $('#image_focusx').val(px)
        $('#image_focusy').val(py)
        $('#image_focusy').trigger('change')
     )
