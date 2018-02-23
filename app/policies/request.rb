# frozen_string_literal: true

# Set up our base presenter; no extensions to Vizier for now
class Request < Checkpoint::Request
  private
    def authority
      @authority ||= Checkpoint::Authority.new(user, action, target)
    end
end
