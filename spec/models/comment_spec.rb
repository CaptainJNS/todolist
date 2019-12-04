require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'with validation' do
    it { is_expected.to validate_presence_of(:body) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:task) }

    it { is_expected.to have_one(:image_attachment) }
  end
end
