class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required
end
