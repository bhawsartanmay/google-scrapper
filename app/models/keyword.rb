class Keyword < ApplicationRecord
  belongs_to :user
  has_many :search_results, dependent: :destroy
  enum status: { pending: 0, completed: 1, failed: 2 }

  mount_uploader :file, KeywordFileUploader
end
