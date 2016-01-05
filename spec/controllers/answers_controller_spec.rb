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

    context "user not signed in" do
      it "redirects to sign in page" do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#edit" do
    context "user signed in" do
      before { log_in(user) }
      before { get :edit, question_id: question, id: answer }

      it "renders the new template" do
        expect(response).to render_template(:edit)
      end

      it "set a instance variable to equal question" do
        expect(assigns(:question)).to eq(question)
      end

      it "set a instance variable to equal question" do
        expect(assigns(:answer)).to eq(answer)
      end
    end

    context "user not signed in" do
      it "redirects to sign in page" do
        get :edit, question_id: question, id: answer
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#update" do
    context "user signed in" do
      before { log_in(user) }

      context "with valid attributes" do
        before do
          patch :update, question_id: question, id: answer, answer: { body: "New Content" }
        end

        it "set a instance variable to equal question" do
          expect(assigns(:question)).to eq(question)
        end

        it "set a instance variable to equal question" do
          expect(assigns(:answer)).to eq(answer)
        end

        it "updates the record in the database" do
          expect(answer.reload.body).to eq("New Content")
        end

        it "redirects to the show page" do
          expect(response).to redirect_to(question_answers_path(question))
        end

        it "sets a flash message" do
          expect(flash[:notice]).to be
        end
      end

      context "with invalid attributes" do
        before do
          patch :update, question_id: question, id: answer, answer: { body: "" }
        end

        it "set a instance variable to equal question" do
          expect(assigns(:question)).to eq(question)
        end

        it "set a instance variable to equal question" do
          expect(assigns(:answer)).to eq(answer)
        end

        it "updates the record in the database" do
          expect(answer.reload.body).not_to eq("")
        end

        it "redirects to the show page" do
          expect(response).to redirect_to(question_answers_path(question))
        end

        it "sets a flash message" do
          expect(flash[:alert]).to be
        end
      end
    end

    context "user not signed in" do
      it "redirects to sign in page" do
        patch :update, question_id: question, id: answer, answer: { body: "New Content" }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#destroy" do
    context "with owner user signed in" do
      before { log_in(user) }
      before { delete :destroy, question_id: question, id: answer }

      it "set a instance variable to equal question" do
        expect(assigns(:question)).to eq(question)
      end

      it "set a instance variable to equal question" do
        expect(assigns(:answer)).to eq(answer)
      end

      it "reduces the number of questions in the database by 1" do
        # I am using answer_1 here because answer is being destroyed above by
        # the before action. So we load answer_1, deleted and check the count.
        answer_1
        expect { delete :destroy, question_id: question, id: answer_1 }.to change { Answer.count }.by(-1)
      end

      it "sets a flash message" do
        expect(flash[:notice]).to be
      end

      it "redirects to the questions quiz show page" do
        expect(response).to redirect_to(question_answers_path(question))
      end
    end
  end
end
