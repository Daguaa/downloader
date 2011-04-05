class AddSizeAndCompletion < ActiveRecord::Migration
  def self.up
    add_column :remote_files, :size, :integer
    add_column :remote_files, :downloaded, :integer
  end

  def self.down
  end
end
