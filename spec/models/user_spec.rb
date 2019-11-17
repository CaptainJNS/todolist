require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation' do
    it { is_expected.to validate_presence_of(:username) }

    it { is_expected.to validate_uniqueness_of(:username) }

    it { is_expected.to validate_length_of(:username).is_at_least(3) }

    it { is_expected.to validate_length_of(:username).is_at_most(50) }

    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_length_of(:password).is_at_least(8) }
  end


  context 'with associations' do
    it { is_expected.to have_many(:projects) }
  end
end
