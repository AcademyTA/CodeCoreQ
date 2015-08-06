require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  describe '#new' do
    it 'instantiates a new user variable' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "with valid parameters" do
      def valid_request
        post :create, 
          { 
            user: {
              name: "John Derpinter",
              email: "jderp@codecore.ca",
              password: "abcd1234",
              password_confirmation: "abcd1234"
            }
          }
      end

      it "creates a user in the database" do
        expect { valid_request }.to change { User.count }.by(1)
      end

      it "sets a flash message" do
        valid_request
        expect(flash[:success]).to be
      end

      it "redirects to the root path of the application" do
        valid_request
        user = User.last
        expect(response).to redirect_to(user)
      end
    end
  end

end
