class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
			t.string :first_name
			t.string :last_name
			t.string :username
			t.string :email
			t.string :city
      t.timestamps
    end
  end
end
