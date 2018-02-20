# frozen_string_literal: true

PRESENTERS = {
  Listing => [ListingPresenter, ListingPolicy],
  User    => [UserPresenter, Vizier::ReadOnlyPolicy],
  'Listing::ActiveRecord_Relation' => [ListingsPresenter, ListingsPolicy],
}

if Swapmeet.config.cache_presenters
  config_class = Vizier::CachingPresenterConfig
else
  config_class = Vizier::PresenterConfig
end

Services = Canister.new
Services.register(:presenters) {
  Vizier::PresenterFactory.new(PRESENTERS, config_type: config_class)
}
