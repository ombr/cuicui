# ApplicationHelper
module ApplicationHelper
  def preview_link
    return image_url(@image) if @image && @image.id
    return section_url(@section) if @section && @section.id
    return site_url(@site) if @site && @site.id
    root_path
  end

  def tab_link(url, html_options = {})
    content_tag :li, class: ('active' if current_page?(url)) do
      link_to url, html_options do
        yield
      end
    end
  end

  def title
    page_title app_name: '', separator: ''
  end
end
