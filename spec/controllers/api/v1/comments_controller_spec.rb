require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create(:project, user_id: user.id) }
  let(:task) { FactoryGirl.create(:task, project_id: project.id) }
  let(:comments) { FactoryGirl.create_list(:comment, 3, task_id: task.id) }

  describe 'GET #index' do
    context 'unauthorized user' do
      it 'returns a unauthorized response 401' do
        task = FactoryGirl.create(:comment).task
        get :index, params: { project_id: task.project_id, task_id: task.id }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'authorized user' do
      before(:each) { request.headers.merge!(user.create_new_auth_token) }
      it 'returns an array of projects comments', :show_in_doc do
        task = comments.first.task
        get :index, params: { project_id: task.project_id, task_id: task.id }
        expect(json.size).to eq(comments.size)
      end
    end
  end

  let(:valid_params) do
    {
      project_id: task.project_id,
      task_id: task.id,
      comment: { body: 'Valid comment!' }
    }
  end

  let(:invalid_params) do
    {
      project_id: task.project_id,
      task_id: task.id,
      comment: { body: 'too short' }
    }
  end

  describe 'POST #create' do
    context 'valid params' do
      it 'returns a created response 201', :show_in_doc do
        request.headers.merge!(user.create_new_auth_token)
        post :create, params: valid_params
        expect(response).to have_http_status :created
        expect(response.content_type).to eq('application/json')
        expect(response).to match_response_schema('project')
      end
    end

    context 'unauthorized user' do
      it 'returns a unauthorized response 401', :show_in_doc do
        post :create, params: valid_params
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'invalid params' do
      it 'returns a unprocessable_entity response 422', :show_in_doc do
        request.headers.merge!(user.create_new_auth_token)
        post :create, params: invalid_params
        expect(response).to have_http_status :unprocessable_entity
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { request.headers.merge!(user.create_new_auth_token) }

    it 'destroy comment by :id', :show_in_doc do
      task = comments.first.task
      expect do
        delete :destroy, params: {
          project_id: task.project_id,
          task_id: task.id,
          id: task.comments.first.id
        }
      end
        .to change(Comment, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
