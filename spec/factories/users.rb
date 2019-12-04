FactoryBot.define do
  factory :user do
    username { FFaker::Name.name }
    password { FFaker::Internet.password }
    password_confirmation { password }
  end
end
