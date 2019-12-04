FactoryBot.define do
  factory :comment do
    body { FFaker::Lorem.paragraph }
    task { create(:task) }
  end
end
