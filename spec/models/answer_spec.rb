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
  end
end
