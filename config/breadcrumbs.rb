crumb :root do
  link t('.home'), user_path(current_user)
end

crumb :sites do
  link t('.my_sites'), sites_path
end

crumb :site do |site|
  if site.new_record?
    link t('.new_site'), new_site_path
  else
    link site.title, edit_site_path(site)
  end
end

crumb :page do |page|
  parent :site, page.site
  if page.new_record?
    link t('.new_page'), new_site_path
  else
    link page.name, edit_page_path(page)
  end
end

crumb :image do |image|
  parent :page, image.page
  link t('.image'), edit_image_path(image)
end

crumb :user do
  link t('.my_account'), edit_user_registration_path
end
