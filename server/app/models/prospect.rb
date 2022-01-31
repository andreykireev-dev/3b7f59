class Prospect < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :campaigns
  belongs_to :prospect_import, optional: true


end
