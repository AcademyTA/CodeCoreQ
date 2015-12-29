require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user)     { create(:user) }
  let(:quiz)     { create(:quiz) }
  let(:question) { create(:question, quiz: quiz) }
  let(:answer)   { create(:answer, question: question) }
  let(:answer_1) { create(:answer, question: question) }

  describe "#new" do
    context "user signed in" do
      before { log_in(user) }
      before { get :new, question_id: question.id }

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "set a instance variable to question" do
        expect(assigns(:question)).to eq(question)
      end
    end

    context "user not signed in" do
      before { get :new, question_id: question.id }

      it "redirects to sign in page" do
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#index" do
    context "user signed in" do
      before { log_in(user) }
      before { get :index, question_id: question.id }

      it "renders the index template" do
        expect(response).to render_template(:index)
      end

      it "set a instance variable to question" do
        expect(assigns(:question)).to eq(question)
      end

      it "set a instance variable to for question answers" do
        answer
        answer_1
        expect(assigns(:answers)).to eq([answer, answer_1])
      end
    end

    context "user not signed in" do
      before { get :index, question_id: question.id }

      it "redirects to sign in page" do
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#create" do
    context "user signed in" do
      before { log_in(user) }

      context "user signed in with valid request" do
        def valid_request
          post :create, question_id: question.id, answer: attributes_for(:answer)
        end

        it "set a instance variable to equal question" do
          valid_request
          expect(assigns(:question)).to eq(question)
        end

        it "creates a new quiz in the database" do
          expect { valid_request }.to change { Answer.count }.by(1)
        end

        it "associates the created campaign to the user" do
          valid_request
          expect( Answer.last.question ).to eq(question)
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end

        it "redirects to quiz questions path" do
          valid_request
          expect(response).to redirect_to(quiz_questions_path(question.quiz))
        end
      end

      context "with invalid request" do
        def invalid_request
          post :create, question_id: question.id, answer: { body: nil }
        end

        it "doesn't create a record in the database" do
          expect { invalid_request }.to change { Answer.count }.by(0)
        end

        it "redirects to the quiz questions path" do
          invalid_request
          expect(response).to redirect_to(quiz_questions_path(question.quiz))
        end

        it "sets a flash message" do
          invalid_request
          expect(flash[:alert]).to be
        end
      end
    end
  end
end
