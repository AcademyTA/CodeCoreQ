require 'rails_helper'

RSpec.describe Answer, type: :model do
  def valid_attributes(new_attributes = {})
    attributes = {body: "This is an answer"}
    attributes.merge(new_attributes)
  end

  describe "Validations" do
    it "requires body text" do
      answer = Answer.new(valid_attributes({body: nil}))
      expect(answer).to be_invalid
    end
    it "requires correct to be a boolean" do
      answer = Answer.new(valid_attributes({correct: nil}))
      expect(answer).to be_invalid
    end
    it "accepts true as a value for correct" do
      answer = Answer.new(valid_attributes({correct: true}))
      expect(answer).to be_valid
    end
    it "accepts false as a value for correct" do
      answer = Answer.new(valid_attributes({correct: false}))
      expect(answer).to be_valid
    end
  end
end
