# frozen_string_literal: true

class Gatekeeper < ApplicationRecord
  belongs_to :domain, optional: true
  belongs_to :group, optional: true
  belongs_to :listing, optional: true
  belongs_to :newspaper, optional: true
  belongs_to :publisher, optional: true
  belongs_to :user, optional: true
end
