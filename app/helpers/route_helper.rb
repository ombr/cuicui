# RouteHelper
module RouteHelper
  def site_url(site, *__args)
    if site.domain?
      root_url(host: site.domain)
    else
      root_url(subdomain: site)
    end
  end

  def see_site_path(site, *_args)
    if site.domain?
      root_url(host: site.domain)
    else
      root_url(subdomain: site)
    end
  end

  def section_url(section, *_args)
    if section.site.domain?
      s_section_url(host: section.site.domain, id: section)
    else
      s_section_url(subdomain: section.site, id: section)
    end
  end

  def section_path(section, *_args)
    site_section_path(id: section, site_id: section.site)
  end

  def next_section_path(section, *_args)
    next_site_section_path(id: section, site_id: section.site)
  end

  def edit_section_path(section, *_args)
    edit_site_section_path(id: section, site_id: section.site)
  end

  def my_edit_site_path(site, *_args)
    edit_site_path(id: site)
  end

  def edit_image_path(image, *_args)
    edit_image_url(site_id: image.site, id: image, section_id: image.section)
  end

  def image_url(image, *_args)
    if image.site.domain?
      s_image_url(host: image.site.domain, id: image, section_id: image.section)
    else
      s_image_url(subdomain: image.site, id: image, section_id: image.section)
    end
  end

  def image_path(image, *_args)
    site_section_image_path(id: image,
                            section_id: image.section,
                            site_id: image.site)
  end

  def preview_image_path(image, *_args)
    s_image_url(id: image, section_id: image.section, site_id: image.site)
  end

  def edit_image_path(image, *_args)
    edit_site_section_image_path(id: image,
                                 section_id: image.section,
                                 site_id: image.site)
  end

  def add_images_url(section, *_args)
    add_site_section_images_path(section_id: section, site_id: section.site)
  end
end
