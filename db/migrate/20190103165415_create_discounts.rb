class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.references :user
      t.integer :type
      t.integer :quantity
      t.integer :discount
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
