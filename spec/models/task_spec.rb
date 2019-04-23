require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title) }

    context 'when tags_limits is exceeded' do
      let(:tag) { create(:tag)}
      let(:task) { create(:task, tags: [tag])}

      specify do
        stub_const("Task::TAGS_LIMIT", 1)
        task.tags << create(:tag)
        expect(task).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:tags) }
  end
end
