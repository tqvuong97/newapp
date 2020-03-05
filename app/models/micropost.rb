# frozen_string_literal: true

class Micropost < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, length: { minimum: 10 }
  paginates_per 5
  belongs_to :category
  has_rich_text :content

  filterrific default_filter_params: { sorted_by: 'created_at_asc' },
              available_filters: %i[sorted_by search_query with_category_id]

  scope :search_query, lambda { |query|
    return nil if query.blank?

    terms = query.to_s.downcase.split(/\s+/)
    terms = terms.map do |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%').prepend('%')
    end
    num_or_conds = 3
    where(
      terms.map do |_term|
        "(LOWER(microposts.title) ILIKE ? OR LOWER(microposts.content) ILIKE ? or (id in (select record_id from action_text_rich_texts where name ilike '%content%' and body ilike ?))) "
      end.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :sorted_by, lambda { |sort_option|
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'
    case sort_option.to_s

    when /^title_/
      order("LOWER(microposts.title) #{direction}")
    when /^content_/
      order("LOWER(microposts.content) #{direction}")
    when /^created_at_/
      order("(microposts.created_at) #{direction}")
    when /^category_/
      joins(:category).order("LOWER(categories.name) #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def self.options_for_sorted_by
    [
      ['Title (A-Z)', 'title_asc'],
      ['Title (Z-A)', 'title_desc'],
      ['Post date (newest first)', 'created_at_desc'],
      ['Post date (oldest first)', 'created_at_asc'],
      ['Category (A-Z)', 'category_asc'],
      ['Category (Z-A)', 'category_desc']

    ]
  end
  scope :with_category_id, lambda { |category_ids|
    where(category_id: [*category_ids])
  }

  scope :with_created_at_gte, lambda { |ref_date|
    where('microposts.created_at >= ?', ref_date)
  }
end
