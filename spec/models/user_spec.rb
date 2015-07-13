require 'rails_helper'

RSpec.describe User, type: :model do

  def valid_attributes(new_attributes = {})

    attributes = {name: "Super", 
                  email: "awesome@codecoreq.ca",
                  password: "abcd1234"}
    attributes.merge(new_attributes)
  end

  describe "Validations" do
    it "requires an name" do
      user = User.new(valid_attributes({name: nil}))
      expect(user).to be_invalid
    end
    it "requires an name longer than 5 characters" do
      user = User.new(valid_attributes({name: "Hi"}))
      expect(user).to be_invalid
    end
    it "requires an name shorter than 30 characters" do
      user = User.new(valid_attributes(
        {name: "Super Long Name that is over 30 characters"}))
      expect(user).to be_invalid
    end
  end

end
