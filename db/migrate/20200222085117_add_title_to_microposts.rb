# frozen_string_literal: true

class AddTitleToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :title, :string
  end
end
