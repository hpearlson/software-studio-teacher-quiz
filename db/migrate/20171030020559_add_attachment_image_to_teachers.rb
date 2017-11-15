class AddAttachmentImageToTeachers < ActiveRecord::Migration
  def self.up
    change_table :teachers do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :teachers, :image
  end
end
