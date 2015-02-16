class Selection < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer

=begin
  validates :points, numericality: true

  after_initialize :set_default_points

  def set_default_points
    self.points ||= 0
  end
=end
end
