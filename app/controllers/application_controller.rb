# frozen_string_literal: true

require 'policy_errors'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :logged_in?

  rescue_from NotAuthorizedError, with: :render_unauthorized
  before_action :set_policy

  protected

    def auto_login(user)
      @current_user = nil
      session[:user_id] = user.id
    end

    def logout!
      @current_user = nil
      session[:user_id] = nil
    end

    def current_user
      @current_user ||= user_from_session || User.guest
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

    def set_policy
      @policy = new_policy
      if current_user.respond_to?(:email) && ['gkostin@umich.edu'].include?(current_user.email)
        @policy = RootPolicy.new([@policy.subject_agent, @policy.object_agent])
      end
      @policy
    end

    # Authorization Policy
    def new_policy
      ApplicationPolicy.new([SubjectPolicyAgent.new(:User, current_user), nil])
    end
end
