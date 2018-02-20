# frozen_string_literal: true

require 'policy_errors'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :logged_in?

  rescue_from NotAuthorizedError, with: :render_unauthorized

  def indexes
  end

  protected

    def present(object)
      Services.presenters[object, current_user, view_context]
    end

    def auto_login(user)
      session[:user_id] = user.id
    end

    def logout!
      session[:user_id] = nil
    end

    def current_user
      unless defined?(@current_user)
        @current_user = user_from_session || User.guest
      end
      @current_user
    end

    def logged_in?
      current_user.known?
    end

    def user_from_session
      User.find_by_id(session.fetch(:user_id, nil))
    end

    def render_unauthorized(_exception = nil)
      respond_to do |format|
        format.html { render 'unauthorized', status: :unauthorized }
        format.json { head :unauthorized }
      end
    end
end
