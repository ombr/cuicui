$('.image-list').html("<%= j render(partial: 'images/image_edit.html', collection: @images, as: :image) %>")
