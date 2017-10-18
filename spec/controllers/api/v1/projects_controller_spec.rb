require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  describe 'GET #index' do
    context 'unauthorized user' do
      it 'returns a unauthorized response 401' do
        get :index
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
