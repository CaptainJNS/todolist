require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:user) }
  end
end
