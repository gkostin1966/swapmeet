# frozen_string_literal: true

class ListingPresenter < ResourcePresenter
  delegate [:edit?, :destroy?] => :policy

  def link_or_title
    if policy.show?
      view.link_to title, listing
    else
      title
    end
  end

  def show_link
    view.link_to 'Show', listing if policy.show?
  end

  def owner
    present(listing.owner)
  end

  private

    alias_method :listing, :resource
end
