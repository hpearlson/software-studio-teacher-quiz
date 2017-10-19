class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :description
      t.integer :course
      t.timestamps 
    end
  end
end
