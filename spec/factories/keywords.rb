FactoryBot.define do
  factory :keyword do
    association :user
    name { Faker::Lorem.word }
    status { 0 }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_file.csv'), 'text/csv') }
  end
end
