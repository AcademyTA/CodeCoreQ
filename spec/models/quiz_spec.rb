require 'rails_helper'

RSpec.describe Quiz, type: :model do
  def valid_attributes(new_attributes = {})
    attributes = {
      title: "Super Fly",
      body: "The CodeCore Q quiz app",
      level: 99,
      category_id: 5
    }
    attributes.merge(new_attributes)
  end

  describe "Validations" do
    it "requires a title" do
      quiz = Quiz.create(valid_attributes({title: nil}))
      expect(quiz).to be_invalid
    end

    it "requires a unique title" do
      quiz   = Quiz.create(valid_attributes)
      quiz_1 = Quiz.create(valid_attributes)
      expect(quiz_1).to be_invalid
    end

    it "requires a body" do
      quiz = Quiz.create(valid_attributes({body: nil}))
      expect(quiz).to be_invalid
    end

    it "requires a level" do
      quiz = Quiz.create(valid_attributes({level: nil}))
      expect(quiz).to be_invalid
    end

    it "requires a level to be a integer, not a string" do
      quiz = Quiz.create(valid_attributes({level: "YAR"}))
      expect(quiz).to be_invalid
    end

    it "will create a quiz with the level as a integer" do
      quiz = Quiz.create(valid_attributes({level: 88}))
      expect(quiz).to be_valid
    end

    it "requires a category_id" do
      quiz = Quiz.create(valid_attributes({category_id: nil}))
      expect(quiz).to be_invalid
    end

    it "requires a category_id to be a integer, not a string" do
      quiz = Quiz.create(valid_attributes({category_id: "Blooper"}))
      expect(quiz).to be_invalid
    end

    it "will create a quiz with the category_id as a integer" do
      quiz = Quiz.create(valid_attributes({category_id: 22}))
      expect(quiz).to be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:category) }
    it { should have_many(:questions) }
    it { should have_many(:user_quizzes) }
    it { should have_many(:users) }
  end

  describe ".per_question_point" do
    it "returns an integer" do
      quiz = Quiz.create(valid_attributes())
      expect(quiz.per_question_point).to be_a(Fixnum)
    end

    it "returns 0 when there are no questions" do
      quiz = Quiz.create(valid_attributes())
      expect(quiz.per_question_point).to eq(0)
    end

    it "returns the correct value 100 / question.count" do
      quiz = Quiz.create(valid_attributes())
      10.times { |num| quiz.questions.create(title: "Cool Story Bro #{num}") }
      expect(quiz.per_question_point).to eq(10)
    end
  end

end
