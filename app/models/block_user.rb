class BlockUser < ApplicationRecord
  # serialize :block_user_ids, Array
  belongs_to :customer
  belongs_to :block_user, class_name: 'Customer', foreign_key: 'block_user_ids'


  def self.block_user user,id
    return user.block_user.present? ? BlockUser.update_entry_block(user,id) :  BlockUser.new_entry_block(user,id)
  end

  def self.new_entry_block user,id
    return user.build_block_user(block_user_ids: [id]).save
  end

  def self.update_entry_block user,id
    ids = user.block_user.block_user_ids
    user = user.block_user.update_attributes(block_user_ids: ids.push(id))
    return user.present? 
  end
end
