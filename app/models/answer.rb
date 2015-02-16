class Answer < ActiveRecord::Base

  belongs_to :question
  has_many :selections, dependent: :destroy
  has_many :users, through: :selections

  validates :body, presence: true
  validates :correct, inclusion: { in: [true, false] }


  def value
    correct ? question.quiz.per_question_point : 0
  end
end
