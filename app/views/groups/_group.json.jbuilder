# frozen_string_literal: true

json.extract! group, :id, :name, :display_name, :created_at, :updated_at
json.url group_url(group, format: :json)
