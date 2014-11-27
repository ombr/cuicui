crumb :root do
  link t('.home'), user_path(id: current_user)
end

crumb :sites do
  link t('.my_sites'), sites_path
end

crumb :site do |site|
  if site.new_record?
    link t('.new_site'), new_site_path
  else
    link site.title, edit_site_path(id: site)
  end
end

crumb :section do |section|
  parent :site, section.site
  if section.new_record?
    link t('.new_section'), new_site_path
  else
    link section.name, edit_section_path(section)
  end
end

crumb :image do |image|
  parent :section, image.section
  link t('.image'), edit_image_path(image)
end

crumb :user do
  link t('.my_account'), edit_user_registration_path
end
