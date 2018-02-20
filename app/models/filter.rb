# frozen_string_literal: true

class Filter
  attr_accessor :newspaper
  attr_accessor :owner
  attr_accessor :category

  attr_reader :newspapers
  attr_reader :owners
  attr_reader :categories

  def initialize(newspapers, owners, categories)
    @newspapers = newspapers.map { |newspaper| [newspaper.display_name, newspaper.id] }
    @owners = owners.map { |owner| [owner.display_name, owner.id] }
    @categories = categories.map { |category| [category.title, category.id] }
  end
end
