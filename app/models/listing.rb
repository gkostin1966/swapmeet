# frozen_string_literal: true

class Listing < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :newspaper
  belongs_to :category
  validates :title, presence: true, allow_blank: false
  validates :body, presence: true, allow_blank: false
end
