class AddEmailToTeachers < ActiveRecord::Migration
  def change
    add_column "teachers", "email_address", :string
  end
end
