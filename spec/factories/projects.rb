FactoryBot.define do
  factory :project do
    name { FFaker::Book.title }
    user { create(:user) }
  end
end
