class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable

  belongs_to :school

  has_many :user_students
  has_many :students, through: :user_students

  has_many :export_lists
    validates_presence_of :first_name, :last_name, :school_id

    has_many :yearbooks
    has_many :headshot_photos, :as => :capturable




end
 