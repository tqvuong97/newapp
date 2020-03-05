# frozen_string_literal: true

class RemoveAvatarFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :avatar, :string
  end
end
