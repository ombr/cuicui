$ ->
  items = $('.rotation .image')
  total = items.length
  if total > 0
    i = 0
    setInterval(()->
      i++
      $('.rotation').scrollTop((i%total)*$(items[0]).height())
    ,5000)
