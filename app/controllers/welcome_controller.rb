class WelcomeController < ApplicationController
 include WelcomeHelper
  before_action :check_login
 
  layout "welcome"
  
  def index
  end


  def about

    redirect_to :index
    # render text: params
    # @quiz = Quiz.find params[:id] 
    # @answer = Answer.find params[:question][:id]
  end


end
