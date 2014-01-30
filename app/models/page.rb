class Page < ActiveRecord::Base
  belongs_to :site
  has_many :images, -> { order('position') }
  acts_as_list scope: :site

  def description_rendered
    md = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      space_after_headers: true
    )
    md.render(description || '')
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def self.reindex
    Site.all.each do |site|
      i = 1
      site.pages.each do |page|
        page.update(position: i)
        i += 1
      end
    end
  end
end
