class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy

  has_one_attached :image

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      image.attach(io: File.open(file_path), filename: 'default_image.jpeg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  def has_member_of(user)
    if group_users.find_by(user_id: user.id)
      true
    else
      false
    end
  end
end
