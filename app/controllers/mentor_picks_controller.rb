class MentorPicksController < ApplicationController
  before_action :must_be_mentor

  def index
  end

  private

  def mentor
    @mentor ||= Mentor.new(current_user)
  end

  def must_be_mentor
    redirect_to root_path, alert: 'You must be a mentor for the current RGSoC season' unless mentor.current?
  end

end
