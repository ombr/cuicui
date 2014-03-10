$ ->
  edit = false
  $('body').on 'input', ()->
    edit = true
  $('body').on 'submit', ()->
    edit = false
    true
  $('body').on 'change', ()->
    edit = true
  $(window).bind 'beforeunload', (e)->
    return 'Some change are not saved.' if edit
