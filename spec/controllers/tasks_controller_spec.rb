require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  shared_examples 'not existing task provided' do
    specify do
      body = %({"errors":[{"title":"Task does not exist", "status": "404", "source":{"pointer":"data/id"}}]})
      expect(subject.body).to be_json_eql(body)
    end
  end

  shared_examples "task's blank title" do
    specify do
      body = %({"errors":[{"title":"Title can't be blank", "status": "422", "source":{"pointer":"data/attributes/title"}}]})
      expect(subject.body).to be_json_eql(body)
    end
  end

  describe 'POST #create' do
    let(:subject) { post :create, params: {title: title} }

    context 'with invalid input data' do
      let(:title) { '' }

      it_behaves_like "task's blank title"
    end

    context 'with correct input data' do
      let(:title) { 'Foo' }

      specify do
        expect { subject }.to change(Task, :count).by(1)
        expect(Task.last.title).to eq('Foo')
        expect(response.status).to eq 201
      end
    end
  end

  describe 'PUT #update' do
    let(:subject) { put :update, params: {id: task.id, title: title} }
    let(:task) { create(:task, title: 'Foo') }

    context 'when not existing task is provided' do
      let(:task) { double(id: -1) }
      let(:title) { 'Bar' }

      it_behaves_like 'not existing task provided'
    end

    context 'with invalid input data' do
      let(:title) { '' }

      it_behaves_like "task's blank title"
    end

    context 'with correct input data' do
      let(:title) { 'Bar' }

      specify do
        expect { subject }.to change { task.reload.title }.to('Bar')
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET #index' do
    let(:subject) { get :index }

    let(:tag) { create(:tag) }
    let!(:task1) { create(:task, title: 'Foo', tags: [tag]) }
    let!(:task2) { create(:task, title: 'Bar') }

    context 'when less than per page are shown' do
      specify do
        expect(subject.body).to have_json_size(2).at_path('data')
        expect(response.status).to eq 200
      end
    end

    context 'when more than per page are shown' do
      specify do
        stub_const("TasksController::INDEX_PER_PAGE", 1)

        expect(subject.body).to have_json_size(1).at_path("data")
        expect(response.status).to eq 200
      end
    end
  end

  describe 'PUT #tag' do
    let(:subject) { put :tag, params: {id: id, name: name} }
    let(:id) { task.id }
    let(:task) { create(:task) }
    let(:name) { 'Foo' }

    context 'with correct tag' do
      context 'with new name' do
        specify do
          expect { subject }
            .to change(Tag, :count).by(1)
            .and change { task.tags.count }.by(1)
          expect(response.status).to eq 200
        end
      end

      context 'with existing name' do
        let!(:existing_tag) { create(:tag, name: 'Foo') }

        specify do
          expect { subject }
            .to change(Tag, :count).by(0)
            .and change { task.tags.count }.by(1)
          expect(response.status).to eq 200
        end
      end
    end

    context 'when incorrect tag' do
      let(:name) { '' }

      specify do
        expect { subject }
          .to change(Tag, :count).by(0)
          .and change { task.tags.count }.by(0)

        body = %({"errors":[{"title":"Name can't be blank", "status": "422", "source":{"pointer":"data/attributes/tags/name"}}]})
        expect(subject.body).to be_json_eql(body)
      end
    end

    context 'when provided task is not found' do
      let(:id) { -1 }

      it_behaves_like 'not existing task provided'
    end
  end

  describe 'DELETE #destroy' do
    let(:subject) { delete :destroy, params: {id: id} }

    context 'when provided the id of not existing skill' do
      let(:id) { -1 }

      it_behaves_like 'not existing task provided'
    end

    context 'when provided id of the existing skill' do
      let!(:tag) { create(:tag) }
      let!(:task) { create(:task, title: 'Foo', tags: [tag]) }
      let(:id) { task.id }

      specify do
        expect { subject }
          .to change(Task, :count).by(-1)
          .and change(TasksTag, :count).by(-1)
          .and change(Tag, :count).by(0)
        expect(response.status).to eq 200
      end
    end
  end
end
