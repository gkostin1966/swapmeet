# frozen_string_literal: true

class Domain < ApplicationRecord
  has_many :children, class_name: "Domain", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Domain", optional: true
  has_many :publishers
  validates :name, presence: true, allow_blank: false
  validates :display_name, presence: true, allow_blank: false
end
