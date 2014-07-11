class Link < ActiveRecord::Base
  belongs_to :user

  validates :slug, presence: true
  validates :target_url, presence: true
end
