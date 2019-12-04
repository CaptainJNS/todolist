FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.word }
    done { false }
    deadline { FFaker::Time.datetime }
    position { 1 }
    project { create(:project) }
  end
end
