module ImagesHelper
  def link_to_image(image, options = {})
    options[:class] ||= ''
    options[:class] += ' scroll'
    options[:'data-scroll'] = "#image-#{image.id}"
    link_to s_image_path(id: image, page_id: image.page), options do
      if block_given?
        yield
      else
        image.title
      end
    end
  end
end
