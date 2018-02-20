# frozen_string_literal: true

class ListingsPresenter < CollectionPresenter
  def new?
    policy.new?
  end

  private

    # `present` can be implemented to use something other than the default
    # presenter and policy resolution.
    #
    # def present(resource)
    #   SpecializedListingPresenter.new(policy.for(listing), view)
    # end

    alias_method :listings, :resources
end
