require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  let(:user)   { create(:user) }
  let(:user_1) { create(:user_1) }

  let(:users) { 4.times.map { create(:user) } }

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

  describe '#show' do
    context "user not signed in" do
      before { get :show, id: user.id }

      it "redirects to sign in page" do
        expect(response).to redirect_to login_path
      end
    end

    context "owner user signed in" do
      before { log_in(user) }
      before { get :show, id: user.id }

      it "renders the show template" do
        expect(response).to render_template(:show)
      end

      it "sets a user instance variable with the id passed" do
        expect(assigns(:user)).to eq(user)
      end
    end

    context "with non-owner user signed in" do
      before { log_in(user) }

      it "raises an error if a non-owners tries to show" do
        expect { get :show, id: user_1.id }.to raise_error
      end
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

    context "with invalid parameters" do
      def invalid_request
        post :create, 
        {
          user: {
            password: "abcd1234",
            password_confirmation: "abcd1234"
          }
        }
      end

      it "doesn't create a user record in the database" do
        expect { invalid_request }.to_not change { User.count }
      end

      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end

      it "sets an alert flash message" do
        invalid_request
        expect(flash[:alert]).to be
      end
    end
  end

  describe '#edit' do
    context "user not signed in" do
      before { get :edit, id: user.id }

      it "redirects to sign in page" do
        expect(response).to redirect_to login_path
      end
    end

    context "owner user signed in" do
      before { log_in(user) }
      before { get :edit, id: user.id }

      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end

      it "sets a user instance variable with the id passed" do
        expect(assigns(:user)).to eq(user)
      end
    end

    context "with non-owner user signed in" do
      before { log_in(user) }

      it "raises an error if a non-owners tries to edit" do
        expect { get :edit, id: user_1.id }.to raise_error
      end
    end
  end

end
