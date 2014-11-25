# ImagesHelper
module ImagesHelper
  def my_image_tag(image, version = :full, options = {})
    return my_image_tag(image.pages.first, version, options) if image.instance_of? Site
    return my_image_tag(image.images.first, version, options) if image.instance_of? Page
    # options[:size] ||= image.geometries[version.to_s] if image.geometries && image.geometries[version.to_s]
    if image
      options[:title] ||= image.seo_title
      options[:alt] ||= image.seo_title
      options[:style] = "background-image: url('#{image.url(:full)}');#{options[:style]}"
      if image.focusx && image.focusy
        options[:style] += "background-position: #{image.focusx}% #{image.focusy}%"
      end
      image_tag image.url(version), options
    else
      image_tag Image.new.url(version), options
    end
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
