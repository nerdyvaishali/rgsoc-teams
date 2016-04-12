# FIXME This is kind of a throwaway class that only serves a purpose as long as
# we don't have a hard DB relation for Project#mentor
class Mentor

  attr_reader :user

  def self.current
    User.joins("RIGHT JOIN projects ON users.github_handle = projects.mentor_github_handle").
      where("projects.season_id" => Season.current.id, "projects.aasm_state" => 'accepted')
  end

  def initialize(user)
    @user = user
  end

  def current?
    self.class.current.include? user
  end

end
