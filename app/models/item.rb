class Item < ApplicationRecord
  scope :owned_by, -> (user) {where(user: user)}

  include PgSearch::Model
  pg_search_scope :search_all_items,
    against: [ :name, :size, :category ],
    associated_against: {
      tags: [:name]
    },
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
  belongs_to :user
  has_and_belongs_to_many :looks, -> { distinct(:id)}
  has_one_attached :photo


  validates :name, :size, presence: true
  validates :category, presence: true
  validates_associated :user, :message => "You have too many items"

  acts_as_taggable_on :tags

  CATEGORIES = ["top", "bottom", "shoes", "outerwear", "accessory"]
end
