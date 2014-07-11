class Link < ActiveRecord::Base
  belongs_to :user

  validates :slug, presence: true
  validates :target_url, presence: true

  def standardize_target_url!
    self.target_url.gsub!("http://", "")
    self.target_url.gsub!("https://", "")
  end
end
