require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user)     { create(:user) }
  let(:quiz)     { create(:quiz) }
  let(:question) { create(:question) }

  describe "#new" do
    context "user not signed in" do
      before { get :new, quiz_id: quiz.id, question: attributes_for(:question) }

      it "redirects to sign in page" do
        expect(response).to redirect_to login_path
      end
    end
  end
end
