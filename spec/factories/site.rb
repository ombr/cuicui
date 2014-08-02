FactoryGirl.define do
  sequence :title do |n|
    "Site #{n}"
  end
  factory :site do
    title
  end
end
