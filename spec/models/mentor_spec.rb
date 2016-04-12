require 'spec_helper'

RSpec.describe Mentor do

  describe '#current?' do
    it 'returns false for nil' do
      subject = described_class.new nil
      expect(subject).not_to be_current
    end

    it 'returns false for a random user' do
      subject = described_class.new create(:user)
      expect(subject).not_to be_current
    end

    it 'returns false for a mentor of the past' do
      old_mentor  = create :user
      old_season  = Season.create name: '2001' # A Space Odyssey!
      create :project, :accepted, mentor_github_handle: old_mentor.github_handle, season: old_season

      subject = described_class.new old_mentor
      expect(subject).not_to be_current
    end

    it 'returns true for a mentor of the here and now' do
      mentor = create :user
      create :project, :accepted, mentor_github_handle: mentor.github_handle, season: Season.current

      subject = described_class.new mentor
      expect(subject).to be_current
    end
  end

end
