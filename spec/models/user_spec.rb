require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation' do
    it 'is invalid without username' do
      expect(build(:user, username: nil)).not_to be_valid
    end

    it 'is invalid with short username' do
      expect(build(:user, username: 'UN')).not_to be_valid
    end

    it 'is invalid with long username' do
      expect(build(:user, username: 'N' * 51)).not_to be_valid
    end

    it 'is invalid without password' do
      expect(build(:user, password: nil, password_confirmation: nil)).not_to be_valid
    end

    it 'is invalid with short password' do
      expect(build(:user, password: 'pass', password_confirmation: 'pass')).not_to be_valid
    end

    it 'is invalid with different password confirmation' do
      expect(build(:user, password: 'password', password_confirmation: 'wordpass')).not_to be_valid
    end

    context 'with associations' do
      it { is_expected.to have_many(:projects) }
    end
  end
end
