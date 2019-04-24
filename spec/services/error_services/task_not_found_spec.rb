require "rails_helper"

RSpec.describe ErrorServices::TaskNotFound do
  describe '#to_json' do
    subject { described_class.new(nil).to_json }

    let(:result) do
      %({"errors":[{"title":"Task does not exist", "status": "404", "source":{"pointer":"data/id"}}]})
    end

    it { is_expected.to be_json_eql(result) }
  end
end
