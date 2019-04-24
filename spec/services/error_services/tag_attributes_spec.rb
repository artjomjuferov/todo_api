require "rails_helper"

RSpec.describe ErrorServices::TagAttributes do
  describe '#to_json' do
    subject { described_class.new(tag).to_json }
    let(:tag) { Tag.create(name: nil) }
    let(:result) do
      %({"errors":[{"title":"Name can't be blank", "status": "422", "source":{"pointer":"data/attributes/tags/name"}}]})
    end

    it { is_expected.to be_json_eql(result) }
  end
end
