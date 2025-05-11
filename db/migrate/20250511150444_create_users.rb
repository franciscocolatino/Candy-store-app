class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.string :cpf, primary_key: true
      t.string :name
      t.string :password_digest
      t.boolean :is_admin

      t.timestamps
    end
  end
end
