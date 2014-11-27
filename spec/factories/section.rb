FactoryGirl.define do
  factory :section do
    name 'Studio Cuicui'
    theme 'light'
    description '### Super description'
    association :site
  end
end
