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
    context 'when less than per page are shown' do
    end

    context 'when more than per page are shown' do
    end
  end

  describe 'PUT #tag' do
    context 'with correct tag' do
    end

    context 'when excesses limit' do
    end
  end

  describe 'DELETE #destroy' do
  end
end
