$ ->
  enable = (e)->
    $submit = $(e).parents('form').find('input[type=submit]')
    $submit.addClass('btn-primary')
  $('body').on 'keydown', 'input', ->
    enable(this)
  $('body').on 'keydown', 'textarea', ->
    enable(this)
  $('body').on 'change', 'textarea', ->
    enable(this)
  $('body').on 'change', 'select', ->
    enable(this)
  $('body').on 'change', 'input', ->
    enable(this)
