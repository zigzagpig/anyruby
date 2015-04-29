class MiniQuora < ActiveRecord::Base
  validates :question, presence: true
  belongs_to :user
end
