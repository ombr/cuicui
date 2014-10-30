# http://www.keenertech.com/articles/2011/06/11/the-empty-string-code-smell-in-rails
module NullifyBlankAttributes
  def write_attribute(attr_name, value)
    new_value = value.presence
    super(attr_name, new_value)
  end
end

# ActiveRecord Monkey Patch.
module ActiveRecord
  # Base
  class Base
    include NullifyBlankAttributes
  end
end
