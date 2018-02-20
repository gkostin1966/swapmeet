class AddNewspaperToListing < ActiveRecord::Migration[5.1]
  def change
    add_reference :listings, :newspaper, index: true
  end
end
