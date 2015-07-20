require 'rails_helper'

RSpec.describe User, type: :model do

  def valid_attributes(new_attributes = {})

    attributes = {name: "Super", 
                  email: "awesome@codecoreq.ca",
                  password: "abcd1234"}
    attributes.merge(new_attributes)
  end

  describe "Validations" do
    it "requires a name" do
      user = User.new(valid_attributes({name: nil}))
      expect(user).to be_invalid
    end
    it "requires a name longer than 5 characters" do
      user = User.new(valid_attributes({name: "Hi"}))
      expect(user).to be_invalid
    end
    it "requires a name shorter than 32 characters" do
      user = User.new(valid_attributes(
        {name: "Super Long Name that is over 32 characters"}))
      expect(user).to be_invalid
    end
    it "requires an email" do
      user = User.new(valid_attributes({email: nil}))
      expect(user).to be_invalid
    end
    it "requires a name shorter than 32 characters" do
      user = User.new(valid_attributes(
        {email: "verylongemail@ddressthatalsohasavalidformat"}))
      expect(user).to be_invalid
    end
    it "requires a valid email" do
      user = User.new(valid_attributes(email: "blabla"))
      expect(user).to be_invalid
    end
    it "requires a unique email" do
      User.create(valid_attributes)
      user = User.new(valid_attributes)
      user.save
      expect(user.errors.messages).to have_key(:email)
    end
    it "changes email's characters to lowercase" do
      user = User.new(valid_attributes({email: "HELLO@EmAiL.CoM"}))
      user.save
      expect(user.email).to eq("hello@email.com")
    end
    it "requires a password" do
      user = User.new(valid_attributes({password: nil}))
      expect(user).to be_invalid
    end
    it "requires a minimum length of 5 characters for the password" do
      user = User.new(valid_attributes({password: "1234"}))
      expect(user).to be_invalid
    end
  end

  describe "Hashing password" do
    it "generates password digest if given a password" do
      user = User.new valid_attributes
      user.save
      expect(user.password_digest).to be
    end
  end

  describe 'associations' do
    it { should have_many(:selections) }
    it { should have_many(:answers) }
    it { should have_many(:user_quizzes) }
    it { should have_many(:quizzes) }
  end

  describe ".downcase_email method" do
    it "changes email's characters to lowercase" do
      u = User.new valid_attributes({email: "CODER@EmAiL.CoM"})
      expect(u.email).to eq("CODER@EmAiL.CoM")
      u.save # because its a before save hook
      expect(u.email).to eq("coder@email.com")
    end
  end

  it { should have_secure_password }

end
