class Question < ActiveRecord::Base
  
  belongs_to :quiz
  has_many :answers, dependent: :destroy

  validates :title, presence: true, uniqueness: true

  def points_per_question
    ( 100 / quiz.questions.count ) * level
  end  
end
