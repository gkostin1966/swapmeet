# frozen_string_literal: true

class User < ApplicationRecord
  has_and_belongs_to_many :groups
  has_many :listings, foreign_key: :owner
  has_and_belongs_to_many :publishers
  has_and_belongs_to_many :newspapers
  validates :username, presence: true, allow_blank: false
  validates :display_name, presence: true, allow_blank: false
  validates :email, presence: true, allow_blank: false

  def self.nobody
    new(username: '<nobody>', display_name: '(No one)', email: '').tap(&:readonly!)
  end

  def self.guest
    new(username: '<guest>', display_name: 'Guest', email: '').tap(&:readonly!)
  end

  def anonymous?
    username == '<nobody>'
  end

  def authenticated?
    username != '<nobody>'
  end

  def identified?
    !anonymous? && authenticated? && username != '<guest>'
  end

  def known?
    persisted?
  end
end
