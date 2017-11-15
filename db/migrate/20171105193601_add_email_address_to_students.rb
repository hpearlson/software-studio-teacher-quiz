class AddEmailAddressToStudents < ActiveRecord::Migration
  def change
    add_column "students", "email_address", :string
  end
end
