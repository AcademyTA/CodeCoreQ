require 'rails_helper'

RSpec.describe Question, type: :model do

  def valid_attributes(new_attributes = {})
    attributes = {title: "My Title"}
    attributes.merge(new_attributes)
  end

  describe "Validations" do
    it "requires a title" do
      question = Question.new(valid_attributes({title: nil}))
      expect(question).to be_invalid
    end
    it "requires a unique email" do
      Question.create(valid_attributes)
      question = Question.new(valid_attributes)
      question.save
      expect(question.errors.messages).to have_key(:title)
    end
  end
  describe 'associations' do
    it { should belong_to(:quiz) }
    it { should have_many(:answers) }
  end
end
