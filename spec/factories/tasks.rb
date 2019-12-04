FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.word }
    done { false }
    deadline { DateTime.now + 1.day }
    position { 1 }
    project { create(:project) }
  end
end
