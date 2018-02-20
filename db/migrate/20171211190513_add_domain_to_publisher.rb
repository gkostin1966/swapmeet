class AddDomainToPublisher < ActiveRecord::Migration[5.1]
  def change
    add_reference :publishers, :domain, index: true
  end
end
