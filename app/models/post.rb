class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image # попробовать has_many
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  validates :image, content_type: { in: %w[image/jpeg image/jpg image/gif image/png image/bmp], # [:jpeg, :jpg, :png, :gif, :bmp],
                                    message: "must be a valid image format" },
                    size: { less_than: 10.megabytes,  
                            message: "should be less than 10MB" }

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

end
