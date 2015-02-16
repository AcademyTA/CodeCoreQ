class Category < ActiveRecord::Base
  
  has_many :quizzes, dependent: :destroy

  validates :title, presence: {message: "Must provide a title!"}, uniqueness: true
end
