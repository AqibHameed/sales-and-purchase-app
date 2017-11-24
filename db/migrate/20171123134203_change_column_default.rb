class ChangeColumnDefault < ActiveRecord::Migration[5.1]
  def change
  	execute <<-SQL
  		UPDATE yes_no_buyer_interests SET buyer_left=1
  	SQL
  end
end
