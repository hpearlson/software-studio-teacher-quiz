class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :description
      t.references :course
      t.string :image
      t.timestamps 
    end
  end
end
