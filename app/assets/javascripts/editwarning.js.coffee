$ ->
  return
  edit = false
  $('body').on 'input', '.warn-on-exit', ()->
    edit = true
  $('body').on 'change', '.warn-on-exit', ()->
    edit = true
  $('body').on 'submit', ()->
    edit = false
    true
  $(window).bind 'beforeunload', (e)->
    return 'Some changes are not saved.' if edit
