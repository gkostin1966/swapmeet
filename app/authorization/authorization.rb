# frozen_string_literal: true #

module Checkpoint
  class Request
    attr_reader :user, :action, :target

    def permitted?
      authority.permits?(user, action, target)
    end

    private

      def authority
        Checkpoint::Authority.new(user, action, target)
      end
  end
end

class ApplicationPolicy
  def authority
    Services.authority
  end
end

class Authorization

  def policy
    # Do we like this better?
    request = Request.new(user, :edit, mongraph)
    request2 = Request.new(user, :with_in, publisher)

    # Or this?
    authority.permits?(user, action, monograph) &&
      authority.permits?(user, action, publisher)

    if request.permitted? || request2.permitted?
      yeah
    end
  end

  def authority_for(user, action, target)
    Checkpoint::Authority.new(user, action, target)
  end

  # def agent_for(entity)
  #   return Checkpoint::Agent.new(entity.class, entity.id)
  # end
  #
  # def resource_for(entity)
  #   return Checkpoint::Resource.new(entity.class, entity.id)
  # end
end

