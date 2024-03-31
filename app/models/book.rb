class Book < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: {maximum: 200}

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      image.attach(io: File.open(file_path), filename: 'default_image.jpeg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "parfect_match"
      @book = Book.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @book = Book.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @book = Book.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @book = Book.where("name LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end
end
