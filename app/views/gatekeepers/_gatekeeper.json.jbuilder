# frozen_string_literal: true

json.extract! gatekeeper, :id, :role, :domain_id, :group_id, :listing_id, :newspaper_id, :publisher_id, :user_id, :created_at, :updated_at
json.url gatekeeper_url(gatekeeper, format: :json)
