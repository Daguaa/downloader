class CreateRemoteFiles < ActiveRecord::Migration
  def self.up
    create_table :remote_files do |t|
      t.string :original_name
      t.integer :site_id
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :remote_files
  end
end
