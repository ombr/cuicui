include CarrierWaveDirect::Test::Helpers
FactoryGirl.define do
  factory :image do
    key { sample_key(FileUploader.new) }
    association :section
  end
end
