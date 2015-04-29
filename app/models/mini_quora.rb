class MiniQuora < ActiveRecord::Base
  validates :question, presence: true
  default_scope -> { order(created_at: :desc) }
  belongs_to :user
end
