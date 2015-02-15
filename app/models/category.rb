class Category < ActiveRecord::Base
  
  has_many :quizzes

  validates :title, presence: {message: "Must provide a title!"}, uniqueness: {scope: :title}

end
