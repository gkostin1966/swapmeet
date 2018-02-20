# frozen_string_literal: true

class PrivilegePresenter < ApplicationPresenter
  delegate :permit?, :revoke?, to: :policy

  def label
    role = model.verb_id
    target =
      case model.object_type
      when "Publisher"
        Publisher.find(model.object_id).display_name
      when "Newspaper"
        Newspaper.find(model.object_id).display_name
      else
        "#{model.object_type}:#{model.object_id}" if model.object_type.present?
      end
    "#{target} #{role}"
  end
end
