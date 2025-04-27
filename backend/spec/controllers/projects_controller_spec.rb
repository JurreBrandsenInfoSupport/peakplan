require 'rails_helper'

describe ProjectsController, type: :controller do
  before do
    setup_authenticated_header
  end

  describe 'GET #index' do
    let!(:user_project1) { Project.create!(title: 'User Project 1', description: 'First project for test user', owner: 'test_user') }
    let!(:user_project2) { Project.create!(title: 'User Project 2', description: 'Second project for test user', owner: 'test_user') }
    let!(:other_user_project) { Project.create!(title: 'Other User Project', description: 'Project owned by another user', owner: 'other_user') }

    it 'returns only projects owned by the current user' do
      get :index, format: :json

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response.size).to eq(2)
      project_titles = json_response.map { |project| project['title'] }
      expect(project_titles).to include('User Project 1', 'User Project 2')
      expect(project_titles).not_to include('Other User Project')
    end

    it 'returns projects in descending order by creation date' do
      get :index, format: :json

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response.first['title']).to eq('User Project 1')
      expect(json_response.last['title']).to eq('User Project 2')
    end
  end
end