class User < ApplicationRecord

  has_one_attached :profile_image
  validates :name,presence: true, uniqueness: true, length: {minimum: 2,maximum: 20}
  validates :introduction, length: {maximum: 50}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

has_many :books, dependent: :destroy
has_many :comments, dependent: :destroy
has_many :favorites, dependent: :destroy

has_many :relationship,class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
has_many :followeds, through: :relationship, source: :followed

has_many :reverse_relationship,class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
has_many :followers, through: :reverse_relationship, source: :follower




    def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image
    end

    def follow(user_id)
      relationship.create(followed_id: user_id)
    end

    def unfollow(user_id)
      relationship.find_by(followed_id: user_id).destroy
    end

    def followed?(user)
      followeds.include?(user)
    end
    
    def self.looks(search, word)
      if search == "perfect_match"
        @user = User.where("name LIKE?", "#{word}")
      elsif search == "foward_match"
        @user = User.where("name LIKE?", "#{word}%")
      elsif search == "backward_match"
        @user = User.where("name LIKE?", "%#{word}")
      elsif search == "partial_match"
        @user = User.where("name LIKE?", "%#{word}%")
      else
        @user = User.all
      end
    end
end
