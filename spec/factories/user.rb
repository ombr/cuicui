FactoryGirl.define do
  factory :user do
    email 'luc@boissaye.fr'
    password 'luclucluc'
    confirmed_at { 5.minutes.ago }
  end
end
