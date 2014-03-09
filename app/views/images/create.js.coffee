$list = $('.image-list')
$list.html("<%= j render(partial: 'images/image_edit.html', collection: @images, as: :image) %>")
$('.control.previous',$list).hide()
$('.control.next',$list).hide()
