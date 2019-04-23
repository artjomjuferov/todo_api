class CreateTasksTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks_tags do |t|
      t.references :tag, foreign_key: true
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
