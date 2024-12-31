FactoryBot.define do
  factory :search_result do
    association :keyword
    total_ads { Faker::Number.between(from: 0, to: 100) }
    total_links { Faker::Number.between(from: 0, to: 1000) }
    total_results { Faker::Number.number(digits: 10).to_s } # Mimics large numbers as strings
    html_cache { Faker::Lorem.paragraph }
  end
end
