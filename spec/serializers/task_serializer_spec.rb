require 'rails_helper'

RSpec.describe TaskSerializer, type: :serializer do
  let(:tag) { build_stubbed(:tag, name: 'Bar') }
  let(:task) { build_stubbed(:task, title: 'Foo', tags: [tag]) }

  subject { TaskSerializer.new(task).to_json }

  specify do
    names = %({"title":"Foo", "tags":[{"name":"Bar"}]})
    is_expected.to be_json_eql(names)

    is_expected.to have_json_path("id")
    is_expected.to have_json_type(Integer).at_path("id")

    is_expected.to have_json_size(1).at_path("tags")
  end
end
