# frozen_string_literal: true

json.extract! domain, :id, :name, :display_name, :parent, :created_at, :updated_at
json.url domain_url(domain, format: :json)
