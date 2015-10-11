class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :roles
  has_many :projects, through: :roles

  def can_view?(project)
    visible_projects.include?(project)
  end

  def visible_projects
    return Project.all.to_a if admin?
    (projects.to_a + Project.all_public.to_a).uniq.sort_by(&:id)
  end
end
