class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  private

  	#验证图片上传的大小
  	def picture_size
	  if picture.size > 5.megabytes
		errors.add(:picture, "不给上传超过 5MB 的图片")
	  end
	end

end