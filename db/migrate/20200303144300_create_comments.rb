# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :micropost, null: false, foreign_key: true
      t.string :body
      t.timestamps
    end
  end
end
