FactoryGirl.define do
  factory :page do
    name 'Studio Cuicui'
    theme 'light'
    description '### Super description'
    association :site
  end
end
