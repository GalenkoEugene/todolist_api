require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create(:project, user_id: user.id) }
  let(:tasks) { FactoryGirl.create_list(:task, 5, project_id: project.id) }
  before(:each) { request.headers.merge!(user.create_new_auth_token) }

  describe 'GET #index' do
    it 'return success response' do
      tasks
      get :index, params: { project_id: project.id }
      expect(response).to have_http_status :ok
      expect(response.content_type).to eq('application/json')
    end

    it 'returns an array of tasks', :show_in_doc do
      tasks
      get :index, params: { project_id: project.id }
      expect(json.size).to eq(tasks.size)
      expect(response).to match_response_schema('tasks')
    end
  end

  let(:task_valid_params) do
    {
      name: FFaker::Movie.unique.title,
      project_id: project.id,
      deadline: Time.zone.tomorrow
    }
  end
  let(:task_invalid_params) do
    {
      name: '',
      deadline: Time.zone.yesterday,
      project_id: project.id
    }
  end

  describe 'POST #create' do
    context 'valid params' do
      it 'returns a created response 201', :show_in_doc do
        post :create, params: { project_id: project.id, task: task_valid_params }
        expect(response).to have_http_status :created
        expect(response.content_type).to eq('application/json')
        expect(response).to match_response_schema('task')
      end

      it 'increase amount of tasks' do
        expect do
          post :create, params: {
            project_id: project.id,
            task: task_valid_params
          }
        end.to change(Task, :count).by 1
      end
    end

    context 'invalid params' do
      it 'returns a unprocessable_entity response 422', :show_in_doc do
        post :create, params: { project_id: project.id, task: task_invalid_params }
        expect(response).to have_http_status :unprocessable_entity
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    let(:new_valid_params) do
      {
        name: 'New owesome name',
        done: true,
        deadline: Time.zone.tomorrow,
        project_id: project.id
      }
    end
    let(:new_invalid_params) do
      {
        deadline: Time.zone.yesterday,
        project_id: project.id
      }
    end

    context 'valid params' do
      it 'update project', :show_in_doc do
        put :update,
            params: {
              id: tasks.sample.id,
              task: new_valid_params,
              project_id: project.id
            }
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema('task')
      end
    end

    context 'invalid params' do
      it 'update project' do
        put :update,
            params: {
              id: tasks.sample.id,
              task: new_invalid_params,
              project_id: project.id
            }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroy task by :id', :show_in_doc do
      tasks
      expect { delete :destroy, params: { project_id: project.id, id: tasks.sample.id } }
        .to change(Task, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
