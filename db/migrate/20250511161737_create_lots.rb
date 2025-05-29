class CreateLots < ActiveRecord::Migration[8.0]
  def change
    create_table :lots do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.date :expiration_date
      t.date :manufacturing_date
      t.date :deleted_at

      t.timestamps
    end
  end
end
