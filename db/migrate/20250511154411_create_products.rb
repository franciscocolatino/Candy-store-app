class CreateProducts < ActiveRecord::Migration[8.0]
    def change
      create_table :products do |t|
        t.string :name
        t.text :description
        t.string :category
        t.decimal :price, precision: 10, scale: 2
        t.date :deleted_at

        t.timestamps
      end
    end
end
