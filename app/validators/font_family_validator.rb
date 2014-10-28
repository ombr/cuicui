# FontFamilyValidator
class FontFamilyValidator < ActiveModel::Validator
  def validate(record)
    options[:fields].each do |field|
      value = record.send(field)
      next if value.nil? && options[:allow_nil]
      next if Font.families.include?(value)
      record.errors[field] << I18n.t('errors.messages.not_a_font_family')
    end
  end
end
