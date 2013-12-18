FactoryGirl.define do
  factory :page do
    name 'Studio Cuicui'
    description '### Super description'
    association :site
  end
end
