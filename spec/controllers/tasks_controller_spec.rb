require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  describe 'POST #create' do
    let(:subject) { post :create, params: {title: title} }

    context 'with invalid input data' do
      let(:title) { '' }

      specify do
        expect { subject }.not_to change(Task, :count)
        expect(response.status).to eq 422
      end
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

      specify do
        subject
        expect(response.status).to eq 404
      end
    end

    context 'with invalid input data' do
      let(:title) { '' }

      specify do
        expect { subject }.not_to change(task, :title)
        expect(response.status).to eq 422
      end
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

    context 'when less than per page are shown' do
      let!(:task) { create(:task, title: 'Foo', tags: [tag]) }
      let!(:tag) { create(:tag, name: 'FooTag') }

      specify do
        # TODO test it
        subject.body
        expect(response.status).to eq 200
      end
    end

    context 'when more than per page are shown' do
      let!(:task1) { create(:task, title: 'Foo') }
      let!(:task2) { create(:task, title: 'Bar') }

      specify do
        stub_const("TasksController::INDEX_PER_PAGE", 1)

        subject.body
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
          expect(response.status).to eq 201
        end
      end

      context 'with existing name' do
        let!(:existing_tag) { create(:tag, name: 'Foo') }

        specify do
          expect { subject }
            .to change(Tag, :count).by(0)
            .and change { task.tags.count }.by(1)
          expect(response.status).to eq 201
        end
      end
    end

    context 'when incorrect tag' do
      let(:name) { '' }

      specify do
        expect { subject }
          .to change(Tag, :count).by(0)
          .and change { task.tags.count }.by(0)
        expect(response.status).to eq 422
      end
    end

    context 'when provided task is not found' do
      let(:id) { -1 }

      specify do
        expect { subject }.not_to change(Task, :count)
        expect(response.status).to eq 404
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:subject) { delete :destroy, params: {id: id} }

    context 'when provided the id of not existing skill' do
      let(:id) { -1 }

      specify do
        expect { subject }.not_to change(Task, :count)
        expect(response.status).to eq 404
      end
    end

    context 'when provided id of the existing skill' do
      let!(:task) { create(:task, title: 'Foo') }
      let(:id) { task.id }

      specify do
        expect { subject }.to change(Task, :count).by(-1)
        expect(response.status).to eq 200
      end
    end
  end
end
