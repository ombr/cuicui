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

  def page_url(page, *_args)
    if page.site.domain?
      s_page_url(host: page.site.domain, id: page)
    else
      s_page_url(subdomain: page.site, id: page)
    end
  end

  def page_path(page, *_args)
    site_page_path(id: page, site_id: page.site)
  end

  def next_page_path(page, *_args)
    next_site_page_path(id: page, site_id: page.site)
  end

  def edit_page_path(page, *_args)
    edit_site_page_path(id: page, site_id: page.site)
  end

  def edit_image_path(image, *_args)
    edit_image_url(site_id: image.site, id: image, page_id: image.page)
  end

  def image_url(image, *_args)
    if image.site.domain?
      s_image_url(host: image.site.domain, id: image, page_id: image.page)
    else
      s_image_url(subdomain: image.site, id: image, page_id: image.page)
    end
  end

  def image_path(image, *_args)
    site_page_image_path(id: image,
                         page_id: image.page,
                         site_id: image.site)
  end

  def preview_image_path(image, *_args)
    s_image_url(id: image, page_id: image.page, site_id: image.site)
  end

  def edit_image_path(image, *_args)
    edit_site_page_image_path(id: image,
                              page_id: image.page,
                              site_id: image.site)
  end

  def add_images_url(page, *_args)
    add_site_page_images_path(page_id: page, site_id: page.site)
  end
end
