# frozen_string_literal: true

json.array! @gatekeepers, partial: 'gatekeepers/gatekeeper', as: :gatekeeper
