# frozen_string_literal: true

class Newspaper < ApplicationRecord
  has_many :listings
end
