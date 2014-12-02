FactoryGirl.define do
  factory :section do
    name { generate :section_name }
    theme 'light'
    description '### Super description'
    association :site
  end
end
