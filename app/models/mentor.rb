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

  def projects
    @projects ||= Project.current.accepted.where(mentor_github_handle: user.github_handle)
  end

  def applications
    @applications ||= begin
                        hstore_query = "application_data @> hstore(:key1, :value) OR application_data @> hstore(:key2, :value)"
                        projects.reduce(Application.none) do |relation, project|
                          relation += Application.where(season: Season.current).
                            where(hstore_query, key1: 'project1_id', key2: 'project2_id', value: project.id.to_s)
                        end
                      end
  end

  def projects_with_applications
    @project_with_applications ||= projects.where(id: project_ids_in_applications)
  end

  private

  def project_ids_in_applications
    @project_ids_in_applications ||= applications.each_with_object([]) do |application, list|
      [application.application_data['project1_id'], application.application_data['project2_id']]
    end.flatten.uniq.reject(&:blank?).map(&:to_i)
  end

end
