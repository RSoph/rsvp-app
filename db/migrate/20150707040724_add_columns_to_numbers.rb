class AddColumnsToNumbers < ActiveRecord::Migration
  def change
  	add_column :numbers, :number, :string
  	add_column :numbers, :count, :integer
  end
end
