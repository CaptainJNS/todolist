FactoryBot.define do
  factory :user do
    username { FFaker::Name.name }
    password { FFaker::Internet.password }
    password_confirmation { password }

    trait :with_project do
      projects { build_list(:project, 1) }
    end

    trait :with_task do
      projects { build_list(:project, 1, tasks: build_list(:task, 1)) }
    end
  end
end
