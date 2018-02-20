# frozen_string_literal: true

class Newspaper < ApplicationRecord
  belongs_to :publisher
  has_many :listings
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :users
  validates :name, presence: true, allow_blank: false
  validates :display_name, presence: true, allow_blank: false
end
