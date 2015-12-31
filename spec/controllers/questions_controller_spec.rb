require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user)     { create(:user) }
  let(:quiz)     { create(:quiz) }
  let(:question) { create(:question, quiz: quiz) }
  let(:answer)   { create(:answer, question: question) }

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

      context "user signed in with valid request" do
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

      context "with invalid request" do
        def invalid_request
          post :create, quiz_id: quiz.id, question: {title: nil}
        end

        it "doesn't create a record in the database" do
          expect { invalid_request }.to change { Question.count }.by(0)
        end

        it "renders the new template" do
          invalid_request
          expect(response).to render_template(:new)
        end

        it "sets a flash message" do
          invalid_request
          expect(flash[:alert]).to be
        end
      end
    end
  end

  describe "#show" do
    context "user signed in" do
      before { log_in(user) }
      before { get :show, quiz_id: quiz, id: question }

      it "renders the new template" do
        expect(response).to render_template(:show)
      end

      it "set a instance variable to equal quiz" do
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "set a instance variable to equal question" do
        expect(assigns(:question)).to eq(question)
      end

      it "set a instance variable for all answers" do
        expect(assigns(:answers)).to eq([answer])
      end
    end

    context "user not signed in" do
      it "redirects to sign in page" do
        get :show, quiz_id: quiz, id: question
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#index" do
    context "user signed in" do
      before { log_in(user) }
      before { get :index, quiz_id: quiz }

      it "renders the new template" do
        expect(response).to render_template(:index)
      end

      it "set a instance variable to equal quiz" do
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "set a instance variable to a new question" do
        expect(assigns(:questions)).to eq([question])
      end
    end

    context "user not signed in" do
      it "redirects to sign in page" do
        get :index, quiz_id: quiz
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#edit" do
    context "user signed in" do
      before { log_in(user) }
      before { get :edit, quiz_id: quiz, id: question }

      it "renders the new template" do
        expect(response).to render_template(:edit)
      end

      it "set a instance variable to equal quiz" do
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "set a instance variable to equal question" do
        expect(assigns(:question)).to eq(question)
      end
    end

    context "user not signed in" do
      it "redirects to sign in page" do
        get :edit, quiz_id: quiz, id: question
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#update" do
    context "with user not signed in" do
      it "redirects new session path" do
        patch :update, id: question, question: { title: "My Title" }
        expect(response).to redirect_to(login_path)
      end
    end

    context "with owner user signed in" do
      before { log_in(user) }

      def valid_attributes(new_attributes = {})
        attributes_for(:question).merge(new_attributes)
      end

      context "with valid attributes" do
        before do
          patch :update, id: question, question: valid_attributes(title: "New Title")
        end

        it "set a instance variable for question" do
          expect(assigns(:question)).to eq(question)
        end

        it "updates the record in the database" do
          expect(question.reload.title).to eq("New Title")
        end

        it "redirects to the show page" do
          expect(response).to redirect_to(quiz_questions_path(question.quiz))
        end

        it "sets a flash message" do
          expect(flash[:notice]).to be
        end
      end

      context "with invalid attributes" do
        before do
          patch :update, id: question, question: valid_attributes(title: "")
        end

        it "set a instance variable for question" do
          expect(assigns(:question)).to eq(question)
        end

        it "doesn't update the record in the database" do
          expect(question.reload.title).to_not eq("")
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

  describe "#destroy" do
    context "with user not signed in" do
      it "redirects new session path" do
        delete :destroy, quiz_id: quiz.id, id: question.id
        expect(response).to redirect_to(login_path)
      end
    end

    context "with owner user signed in" do
      before { log_in(user) }

      it "set a instance variable to equal quiz" do
        delete :destroy, quiz_id: quiz.id, id: question.id
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "set a instance variable to equal question" do
        delete :destroy, quiz_id: quiz.id, id: question.id
        expect(assigns(:question)).to eq(question)
      end

      it "reduces the number of questions in the database by 1" do
        question
        expect { delete :destroy, quiz_id: quiz.id, id: question.id }.
          to change { Question.count }.by(-1)
      end

      it "sets a flash message" do
        delete :destroy, quiz_id: quiz.id, id: question.id
        expect(flash[:notice]).to be
      end

      it "redirects to the questions quiz show page" do
        delete :destroy, quiz_id: quiz.id, id: question.id
        expect(response).to redirect_to(quiz_questions_path(quiz))
      end
    end
  end
end
