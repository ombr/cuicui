class ReverseOrder < ActiveRecord::Migration
  def reverse(list)
    total = list.count
    list.each do |item|
      item.position = total - item.position + 1
      item.save!
    end
  end

  def change
    reverse Site.first.pages
    Site.first.pages.each do |p|
      reverse p.images
    end
  end
end
