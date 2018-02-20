# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :children, class_name: "Group", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Group", optional: true
  has_and_belongs_to_many :users
  has_and_belongs_to_many :publishers
  has_and_belongs_to_many :newspapers
  validates :name, presence: true, allow_blank: false
  validates :display_name, presence: true, allow_blank: false
end
