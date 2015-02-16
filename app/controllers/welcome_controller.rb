class WelcomeController < ApplicationController
  protect_from_forgery with: :exception
  include SessionsHelper
  layout "welcome"
  
  def index
  end

  def about
    
    @quiz = Quiz.find params[:id] 
    @answer = Answer.find params[:question][:id]
    
    render text: @answer

  end


end
