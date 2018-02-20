# frozen_string_literal: true

# Set up our base presenter; no extensions to Vizier for now
class CollectionPresenter < Vizier::CollectionPresenter
  protected
    def presenter_factory
      Services.presenters
    end
end
