require 'spec_helper'

RSpec.describe MentorPicksController do
  let(:user) { create :user }

  context 'with a user logged in' do
    before do
      allow(controller).to receive_messages(signed_in?: true)
      allow(controller).to receive_messages(current_user: user)
    end

    shared_context 'as a mentor' do
      let!(:project) { create :project, :accepted, mentor_github_handle: user.github_handle, season: Season.current }
    end

    describe 'GET index' do
      it 'redirects to the root path' do
        get :index
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to be_present
      end

      context 'as a mentor' do
        include_context 'as a mentor'
        it 'renders the index template' do
          get :index
          expect(response).to render_template 'index'
        end
      end
    end

  end
end
