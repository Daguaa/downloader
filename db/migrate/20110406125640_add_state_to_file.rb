class AddStateToFile < ActiveRecord::Migration
  def self.up
    add_column :remote_files, :state, :string
  end

  def self.down
  end
end
