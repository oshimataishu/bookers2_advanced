class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  GUEST_EMAIL = "guest@example.com"
  GUEST_NAME = "Guest"

  geocoded_by :address
  after_validation :geocode

  include JpPrefecture
  jp_prefecture :prefecture_code

  has_one_attached :profile_image

  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy

  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true,
                   length: {minimum: 2, maximum: 20},
                   uniqueness: true
  validates :introduction, length: {maximum: 50}
  # validates :address, presence: true
  # validates :postcode, presence: true

  def self.find_or_create_guest
    find_or_create_by!(email: GUEST_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = GUEST_NAME
    end
  end

  def guest_user?
    if email != GUEST_EMAIL
      redirect_to user_path(current_user), notice: 'You are not allowed to edit profile'
    end
  end


  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'default_image.jpeg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def following?(user)
    if active_relationships.exists?(followed_id: user.id)
      return true
    end
  end

  def followed_by?(user)
    if passive_relationships.exists?(follower_id: user.id)
      return true
    end
  end

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def self.looks(search, word)
    if search == "parfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end


  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefeture.find(name: prefecture_name).code
  end
end
