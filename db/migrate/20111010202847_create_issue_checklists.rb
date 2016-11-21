class CreateIssueChecklists < ActiveRecord::Migration
  def self.up
    create_table :issue_checklists do |t|
      t.boolean :is_done, default: false
      t.string :subject
      t.integer :position, default: 1
      t.references :issue, null: false
    end
  end

  def self.down
    drop_table :issue_checklists
  end
end
