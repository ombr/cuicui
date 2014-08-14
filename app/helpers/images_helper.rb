module ImagesHelper
  def my_image_tag(image, version, options = {})
    options[:size] ||= image.geometries[version.to_s] if image.geometries && image.geometries[version.to_s]
    options[:title] ||= image.title
    options[:alt] ||= image.title
    options[:style] = "background-image: url('#{image.url(:full)}');#{options[:style]}"
    image_tag image.url(:full), options
  end

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
