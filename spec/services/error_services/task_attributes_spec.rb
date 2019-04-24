require "rails_helper"

RSpec.describe ErrorServices::TaskAttributes do
  describe '#to_json' do
    subject { described_class.new(task).to_json }

    let(:task) { Task.create(title: nil) }
    let(:result) do
      %({"errors":[{"title":"Title can't be blank", "status": "422", "source":{"pointer":"data/attributes/title"}}]})
    end

    it { is_expected.to be_json_eql(result) }
  end
end
