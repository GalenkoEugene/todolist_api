module ControllerMacros
  def login_user(user = false)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user ||= FactoryGirl.create(:user)
      sign_in user
      request.headers.merge!(user.create_new_auth_token)
    end
  end
end
