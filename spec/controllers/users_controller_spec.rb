require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  let(:user)   { create(:user) }
  let(:user_1) { create(:user) }
  let(:users)  { 4.times.map { create(:user) } }
  let(:quiz)   { create(:quiz) }
  let(:quiz_1) { create(:quiz) }

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

  describe '#index' do
    context "user not signed in" do
      before { get :index, id: user.id }

      it "redirects to sign in page" do
        expect(response).to redirect_to login_path
      end

      it "sets a users instance variable" do
        expect(assigns(:users)).not_to be
      end

      it "sets a quizzes instance variable" do
        expect(assigns(:quizzes)).not_to be
      end
    end

    context "owner user signed in" do
      before { log_in(user) }
      before { get :index, id: user.id }

      it "renders the index template" do
        expect(response).to redirect_to(users_url)
      end

      it "sets a users instance variable" do
        expect(assigns(:users)).to eq([user, user_1])
      end

      it "sets a quizzes instance variable" do
        expect(assigns(:quizzes)).to eq([quiz, quiz_1])
      end
    end
  end

  describe '#show' do
    context "user not signed in" do
      before { get :show, id: user.id }

      it "does not set a user instance variable" do
        expect(assigns(:users)).not_to be
      end

      it "does not set a quizzes instance variable" do
        expect(assigns(:quizzes)).not_to be
      end

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

      it "sets a user instance variable" do
        expect(assigns(:user)).to eq(user)
      end

      it "sets a quizzes instance variable" do
        expect(assigns(:quizzes)).to eq([quiz, quiz_1])
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
  end

  describe "#update" do
    context "with user not signed in" do
      it "does not set a user instance variable" do
        expect(assigns(:user)).not_to be
      end

      it "redirects log_in path" do
        patch :update, id: user.id, user: {name: "Lolo Jones"}
        expect(response).to redirect_to(login_path)
      end
    end

    context "with owner user signed in" do
      before { log_in(user) }

      def valid_attributes(new_attributes = {})
        attributes_for(:user).merge(new_attributes)
      end

      context "with valid attributes" do
        before do
          patch :update,
            id:   user.id, 
            user: valid_attributes(name: "Yaya I am Lorde")
        end

        it "sets a user instance variable with the id passed" do
          expect(assigns(:user)).to eq(user)
        end

        it "updates the record in the database" do
          expect(user.reload.name).to eq "Yaya I am Lorde"
        end

        it "redirects to the show page" do
          expect(response).to redirect_to(user_path(user))
        end

        it "sets a flash message" do
          expect(flash[:success]).to be
        end
      end

      context "with invalid attributes" do
        before do
          patch :update, 
            id:   user.id, 
            user: valid_attributes(name: "")
        end

        it "doesn't update the record in the database" do
          expect(user.reload.name).to_not eq("")
        end

        it "renders the edit template" do
          expect(response).to render_template(:edit)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to be
        end
      end
    end
  end

end
