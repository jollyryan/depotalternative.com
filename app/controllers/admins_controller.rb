class AdminsController < ApplicationController
  
  load_and_authorize_resource :class => "AdminsController"
  
  def index
  end


end
