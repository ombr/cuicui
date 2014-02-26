$ ()->
  $('.image-list').each (i,list)->
    #$('.next', list).hide()
    #$('.previous', list).hide()
    $(list).sortable(
      update: (e, ui) ->
        $form = $('.next,.previous', ui.item)
        $input = $('input[name="image[position]"]', $form)
        $input.val($('li', list).index($(ui.item)) + 1)
        $form.submit()
    )

