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
  end

  # describe "Hashing password" do
  #   it "generates password digest if given a password" do
  #     user = User.new valid_attributes
  #     user.save
  #     expect(user.password_digest).to be
  #   end
  # end

end
