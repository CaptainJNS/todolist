require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'with validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:project) }
  end
end
