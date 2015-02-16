class WelcomeController < ApplicationController
 include WelcomeHelper
  before_action :check_login
 
  layout "welcome"
  
  def index
  end


  def about
    
    @quiz = Quiz.find params[:id] 
    @answer = Answer.find params[:question][:id]
    
    render text: @answer

  end


end
