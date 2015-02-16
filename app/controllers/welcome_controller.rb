class WelcomeController < ApplicationController
 include WelcomeHelper
  before_action :check_login
 
  layout "welcome"
  
  def index
  end
end