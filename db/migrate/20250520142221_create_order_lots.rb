class CreateOrderLots < ActiveRecord::Migration[8.0]
  def change
    create_table :order_lots, id: false do |t|
      t.integer :quantity, null: false, default: 1
      t.boolean :is_delivered, default: false
      t.float :subtotal, null: false, default: 0.0
      t.references :order, null: false, foreign_key: true
      t.references :lot, null: false, foreign_key: true

      t.timestamps
    end

    execute "ALTER TABLE order_lots ADD PRIMARY KEY (order_id, lot_id);"
  end
end
