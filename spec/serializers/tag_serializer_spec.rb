
require 'rails_helper'

RSpec.describe TagSerializer, type: :serializer do
  let(:tag) { build_stubbed(:tag, name: 'Bar') }

  subject { TagSerializer.new(tag).to_json }

  specify do
    names = %({"name":"Bar"})
    is_expected.to be_json_eql(names)
    is_expected.to have_json_path('id')
  end
end
