require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  let(:user)           { create(:user) }
  let(:quiz)           { create(:quiz) }
  let(:quiz_1)         { create(:quiz) }
  let(:category)       { create(:category) }
  let(:all_categories) { create_list(:category, 5) }
  let(:question)       { create(:question) }
  let(:all_questions)  { create_list(:question, 5) }

  describe "#new" do
    context "user signed in" do
      before { log_in(user) }
      before { get :new }

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "set a instance variable to a new quiz" do
        expect(assigns(:quiz)).to be_a_new Quiz
      end

      it "set a instance variable to for all categories" do
        all_categories
        expect(assigns(:categories)).to eq(Category.all)
      end
    end

    context "user not signed in" do
      before { get :new }
      it "redirects to sign in page" do
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#create" do
    context "user signed in" do
      before { log_in(user) }

      context "with valid parameters" do
        def valid_request
          post :create,
            { 
              quiz: {
                title: "Remember the Titans",
                body: "Aint no mountain high enough",
                level: 10,
                category_id: 6
              }
            }
        end

        it "set a instance variable to for all categories" do
          all_categories
          valid_request
          expect(assigns(:categories)).to eq(Category.all)
        end

        it "creates a new quiz in the database" do
          expect { valid_request }.to change { Quiz.count }.by(1)
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:success]).to be
        end

        it "redirect to quiz show page" do
          valid_request
          expect(response).to redirect_to(quiz_path(Quiz.last))
        end
      end

      context "with invalid parameters" do
        def invalid_request
          post :create, quiz: {title: "Lols Yo, Derp Derp"}
        end

        it "set a instance variable to for all categories" do
          all_categories
          invalid_request
          expect(assigns(:categories)).to eq(Category.all)
        end

        it "doesn't create a record in the database" do
          expect { invalid_request }.to change { Quiz.count }.by(0)
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

    context "user not signed in" do
      it "redirects to sign in page" do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#show" do
    context "user signed in" do
      before { log_in(user) }

      def valid_request
        quiz.category_id = category.id
        quiz.questions   = all_questions
        quiz.save
        get :show, id: quiz
      end

      it "renders the new template" do
        valid_request
        expect(response).to render_template(:show)
      end

      it "set a instance variable for quiz" do
        valid_request
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "set a instance variable to for all categories" do
        valid_request
        expect(assigns(:category)).to eq(category)
      end

      it "set a instance variable to for all quiz questions" do
        valid_request
        expect(assigns(:questions)).to eq(all_questions)
      end
    end
  end

  describe "#index" do
    context "user signed in" do
      before { log_in(user) }
      before { get :index }

      it "renders the new template" do
        expect(response).to render_template(:index)
      end

      it "set a instance variable for all quizzes" do
        expect(assigns(:quizzes)).to eq(Quiz.all)
      end

      it "set a instance variable to for all categories" do
        all_categories
        expect(assigns(:categories)).to eq(Category.all)
      end
    end

    context "user not signed in" do
      before { get :index }

      it "renders the new template" do
        expect(response).to render_template(:index)
      end

      it "set a instance variable for all quizzes" do
        quiz
        quiz_1
        expect(assigns(:quizzes)).to eq([quiz, quiz_1])
      end

      it "set a instance variable to for all categories" do
        all_categories
        expect(assigns(:categories)).to eq(Category.all)
      end
    end
  end

  describe "#edit" do
    context "user signed in" do
      before { log_in(user) }
      before { get :edit, id: quiz }

      it "renders the new template" do
        expect(response).to render_template(:edit)
      end

      it "set a instance variable for quiz" do
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "set a instance variable to for all categories" do
        all_categories
        expect(assigns(:categories)).to eq(Category.all)
      end
    end

    context "user not signed in" do
      before { get :edit, id: quiz }
      it "redirects to sign in page" do
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#update" do
    context "with user not signed in" do
      it "redirects new session path" do
        patch :update, id: quiz, quiz: {title: "some valid title"}
        expect(response).to redirect_to(login_path)
      end
    end

    context "with owner user signed in" do
      before { log_in(user) }

      def valid_attributes(new_attributes = {})
        attributes_for(:quiz).merge(new_attributes)
      end

      context "with valid attributes" do
        before do
          patch :update, id: quiz, quiz: valid_attributes(title: "new title")
        end

        it "set a instance variable for quiz" do
          expect(assigns(:quiz)).to eq(quiz)
        end

        it "updates the record in the database" do
          expect(quiz.reload.title).to eq("new title")
        end

        it "redirects to the show page" do
          expect(response).to redirect_to(quizzes_path)
        end

        it "sets a flash message" do
          expect(flash[:success]).to be
        end
      end
    end
  end




end
