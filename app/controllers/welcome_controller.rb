class WelcomeController < ApplicationController
  protect_from_forgery with: :exception
  include SessionsHelper
  layout "welcome"
  
  def index
  end
end
