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



# {
#  { version: 1.0, force_upgrade: true, recommendUpgrade: true },
#  { version: 1.2, forceUpgrade: true, recommendUpgrade: true },
#  { version: 2.0, forceUpgrade: false, recommendUpgrade: false },
# }


