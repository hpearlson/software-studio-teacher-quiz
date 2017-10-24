class AddUsernameToTeachers < ActiveRecord::Migration
  def change
    add_column "teachers", "username", :string
  end
end
