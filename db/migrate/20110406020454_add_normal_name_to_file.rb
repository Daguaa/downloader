class AddNormalNameToFile < ActiveRecord::Migration
  def self.up
    add_column :remote_files, :name, :string
  end

  def self.down
  end
end
