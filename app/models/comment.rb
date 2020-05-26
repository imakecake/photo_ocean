class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one_attached :image
  validates :post_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true
  validates :image, content_type: { in: %w[image/jpeg image/jpg image/gif image/png image/bmp], # [:jpeg, :jpg, :png, :gif, :bmp],
                                    message: "must be a valid image format" },
                    size: { less_than: 10.megabytes,  
                            message: "should be less than 10MB" }

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

end
