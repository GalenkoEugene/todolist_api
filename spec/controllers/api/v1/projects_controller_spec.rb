require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:projects) { FactoryGirl.create_list(:project, 5, user_id: user.id) }

  describe 'GET #index' do
    context 'unauthorized user' do
      it 'returns a unauthorized response 401' do
        get :index
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'authorized user' do
      before { request.headers.merge!(user.create_new_auth_token) }

      it "returns an array of user's projects", :show_in_doc do
        projects
        get :index
        expect(json.size).to eq(projects.size)
        expect(response).to match_response_schema('projects')
      end
    end
  end

  let(:project_valid_params) do
    { name: FFaker::Movie.unique.title }
  end
  let(:project_invalid_params) { { name: '' } }

  describe 'POST #create' do
    context 'valid params' do
      login_user
      it 'returns a created response 201', :show_in_doc do
        post :create, params: { project: project_valid_params }
        expect(response).to have_http_status :created
        expect(response.content_type).to eq('application/json')
        expect(response).to match_response_schema('project')
      end
    end

    context 'unauthorized user' do
      it 'returns a unauthorized response 401', :show_in_doc do
        post :create, params: { project: project_valid_params }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'invalid params' do
      login_user
      it 'returns a unprocessable_entity response 422', :show_in_doc do
        post :create, params: { project: project_invalid_params }
        expect(response).to have_http_status :unprocessable_entity
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    let(:new_valid_name) do
      { name: 'New owesome name' }
    end
    let(:new_invalid_name) do
      { name: '' }
    end

    before { request.headers.merge!(user.create_new_auth_token) }

    context 'valid params' do
      it 'update project', :show_in_doc do
        put :update, params: { id: projects.sample.id, project: new_valid_name }
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema('project')
      end
    end

    context 'invalid params' do
      it 'update project' do
        put :update, params: { id: projects.sample.id, project: new_invalid_name }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { request.headers.merge!(user.create_new_auth_token) }

    it 'destroy project by :id', :show_in_doc do
      projects
      expect { delete :destroy, params: { id: projects.sample.id } }
        .to change(Project, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
