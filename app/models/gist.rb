class Gist < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :url, presence: true

  def hash_id
    url.split("/").last
  end
end
