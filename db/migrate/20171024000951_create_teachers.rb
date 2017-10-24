class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :first_name
      t.string :last_name
      t.string :description
      t.string :password_digest
      t.string :username
      t.timestamps
    end
  end
end
