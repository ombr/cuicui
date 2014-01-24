#if $.cookie('hide-control')
  #$('.viewer').removeClass('auto-control')
#if $.cookie('hide-control') == 'true'
  #$('.viewer').addClass('hide-control')
#$('body').on 'click', '.viewer', (e)->
  #link = $(e.target).attr('href')
  #unless link?
    #$(this).toggleClass('hide-control')
    #$(this).removeClass('auto-control')
    #$.cookie('hide-control',$(this).hasClass('hide-control'), path: '/')
    #
#$('body').on 'click', '.viewer', (e)->
  #link = $(e.target).attr('href')
  #unless link?
    #if $(this).hasClass('auto-control')
      #$(this).removeClass('auto-control')
    #else
      #$(this).toggleClass('hide-control')
