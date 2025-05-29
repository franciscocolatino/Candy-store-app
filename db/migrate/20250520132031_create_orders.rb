class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.float :total_price, default: 0.0
      t.boolean :is_finished, default: false
      t.datetime :date, default: -> { 'CURRENT_TIMESTAMP' }
      t.references :table, foreign_key: true, null: true
      t.string :user_cpf, null: false

      t.timestamps
    end

    add_index :orders, :user_cpf
    add_foreign_key :orders, :users, column: :user_cpf, primary_key: :cpf
  end
end
