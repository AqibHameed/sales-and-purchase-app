class CreateAppVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :app_versions do |t|
      t.string :version
      t.boolean :force_upgrade
      t.boolean :recommend_upgrade
      t.timestamps
    end
  end
end


