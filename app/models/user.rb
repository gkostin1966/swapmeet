# frozen_string_literal: true

class User < ApplicationRecord
  has_many :listings, foreign_key: :owner

  def self.nobody
    new(username: '<nobody>', display_name: '(No one)', email: '').tap(&:readonly!)
  end

  def self.guest
    new(username: '<guest>', display_name: 'Guest', email: '').tap(&:readonly!)
  end

  def known?
    persisted?
  end

  def root?
    id == 1
  end
end
