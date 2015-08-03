require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user)   { create(:user) }
  let(:user_1) { create(:user_1) }

  describe "#new" do
    it "instantiates a new user variable" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

end
