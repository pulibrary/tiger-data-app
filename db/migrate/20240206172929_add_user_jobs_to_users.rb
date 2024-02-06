class AddUserJobsToUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_jobs do |t|
      t.belongs_to :user
      t.string :job_id
      t.timestamps
    end
  end
end
