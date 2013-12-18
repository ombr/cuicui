class Page < ActiveRecord::Base
  belongs_to :site
  has_many :images, -> { order('position DESC') }
  acts_as_list scope: :site

  def description_html
    md = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      space_after_headers: true
    )
    md.render(description || '')
  end
end
