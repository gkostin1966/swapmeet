# frozen_string_literal: true

class UserPresenter < ResourcePresenter
  def display_name_link
    view.link_to_if known?, display_name, user
  end

  private

    alias_method :user, :resource
end
