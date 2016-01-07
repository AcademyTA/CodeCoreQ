require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:quiz)     { create(:quiz) }
  let(:question) { create(:question, quiz: quiz) }

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
  
  describe 'associations' do
    it { should belong_to(:question) }
    it { should have_many(:selections) }
    it { should have_many(:users) }
  end

  describe "value method" do
    it "returns an integer" do
      answer = question.answers.create(valid_attributes())
      expect(answer.value).to be_a(Fixnum)
    end

    it "returns 100 for a true value" do
      answer = question.answers.create(valid_attributes({correct: true}))
      expect(answer.value).to be(100)
    end

    it "returns 0 for a false value" do
      answer = question.answers.create(valid_attributes({correct: true}))
      expect(answer.value).to be(100)
    end
  end
end
