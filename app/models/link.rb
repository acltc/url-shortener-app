class Link < ActiveRecord::Base
  has_many :visits
  belongs_to :user

  validates :slug, presence: true
  validates :target_url, presence: true

  def standardize_target_url!
    self.target_url.gsub!("http://", "")
    self.target_url.gsub!("https://", "")
  end

  def visit_count
    self.visits.count
  end
end
