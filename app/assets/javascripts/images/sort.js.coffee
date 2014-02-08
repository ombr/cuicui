$ ()->
  $('.image-list').each (i,list)->
    $('.next', list).hide()
    $('.previous', list).hide()
    $(list).sortable(
      update: (e, ui) ->
        $form = $('.next,.previous', ui.item)
        $input = $('input[name="image[position]"]', $form)
        console.log 'UPDATE ?'
        console.log $form
        console.log $input
        console.log($('li', list).index($(ui.item)) + 1)
        $input.val($('li', list).index($(ui.item)) + 1)
        $form.submit()
    )

