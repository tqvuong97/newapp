# frozen_string_literal: true

class ChangeUserIdFromComments < ActiveRecord::Migration[6.0]
  def change
    change_column :comments, :user_id, :bigint, null: true
    change_column :comments, :micropost_id, :bigint, null: true
  end
end
