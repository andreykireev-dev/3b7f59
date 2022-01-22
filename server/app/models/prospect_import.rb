class ProspectImport < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  enum status: {
    uploading: 0, 
    processing: 1, 
    completed: 2, 
    purged: 3
  }, _default: 0
end
