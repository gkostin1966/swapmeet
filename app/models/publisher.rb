# frozen_string_literal: true

class Publisher < ApplicationRecord
  belongs_to :domain, optional: true
  has_many :newspapers
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :users
  validates :name, presence: true, allow_blank: false
  validates :display_name, presence: true, allow_blank: false
end
