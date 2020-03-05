# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :microposts
  def self.options_for_select
    categories = Category.arel_table
    order(categories[:name].lower).pluck(:name, :id)
  end
end
