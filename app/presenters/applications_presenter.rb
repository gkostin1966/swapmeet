# frozen_string_literal: true

class ApplicationsPresenter
  attr_reader :user, :policy, :models, :presenters

  def initialize(user, policy, models, presenters)
    @user = user
    @policy = policy
    @models = models
    @presenters = presenters
  end

  delegate :index?, :show?, :new?, :create?, :edit?, :update?, :destroy?, to: :policy

  delegate :empty?, :count, :each, to: :presenters
end
