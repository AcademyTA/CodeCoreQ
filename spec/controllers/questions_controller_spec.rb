require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user)     { create(:user) }
  let(:quiz)     { create(:quiz) }
  let(:question) { create(:question) }

  describe "#new" do
    context "user signed in" do
      before { log_in(user) }
      before { get :new, quiz_id: quiz.id, question: attributes_for(:question) }

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "set a instance variable to equal quiz" do
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "set a instance variable to a new question" do
        expect(assigns(:question)).to be_a_new Question
      end
    end

    context "user not signed in" do
      before { get :new, quiz_id: quiz.id, question: attributes_for(:question) }

      it "redirects to sign in page" do
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#create" do
    context "user not signed in" do
      before { post :create, quiz_id: quiz.id, question: attributes_for(:question) }

      it "redirects to sign in page" do
        expect(response).to redirect_to login_path
      end
    end

    context "user signed in" do
      before { log_in(user) }

      def valid_request
        post :create, quiz_id: quiz.id, question: attributes_for(:question)
      end

      it "set a instance variable to equal quiz" do
        valid_request
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "creates a new quiz in the database" do
        expect { valid_request }.to change { Question.count }.by(1)
      end

      it "sets a flash message" do
        valid_request
        expect(flash[:notice]).to be
      end

      it "redirects to quiz questions path" do
        valid_request
        expect(response).to redirect_to(quiz_questions_path)
      end
    end
  end
end
