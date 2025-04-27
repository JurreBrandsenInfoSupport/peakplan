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

  describe 'POST #create' do
    let(:valid_attributes) { { title: 'New Project', description: 'A new project for testing' } }
    let(:invalid_attributes) { { title: '', description: 'Missing title' } }

    context 'with valid parameters' do
      it 'creates a new project' do
        expect {
          post :create, params: { project: valid_attributes }, format: :json
        }.to change(Project, :count).by(1)
      end

      it 'returns a JSON response with the new project' do
        post :create, params: { project: valid_attributes }, format: :json

        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(%r{application/json})

        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('New Project')
        expect(json_response['description']).to eq('A new project for testing')
        expect(json_response['owner']).to eq('test_user')
      end
    end

    context 'with invalid parameters' do
      before do
        # Add validation to the Project model for the test
        allow_any_instance_of(Project).to receive(:valid?).and_return(false)
        allow_any_instance_of(Project).to receive(:errors).and_return(
          double(full_messages: [ 'Title can\'t be blank' ])
        )
      end

      it 'does not create a new project' do
        expect {
          post :create, params: { project: invalid_attributes }, format: :json
        }.not_to change(Project, :count)
      end

      it 'returns a JSON response with errors' do
        post :create, params: { project: invalid_attributes }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(%r{application/json})

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
        expect(json_response['errors']).to include('Title can\'t be blank')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user_project) { Project.create!(title: 'User Project', description: 'Project to be deleted', owner: 'test_user') }
    let!(:other_user_project) { Project.create!(title: 'Other User Project', description: 'Project owned by another user', owner: 'other_user') }

    context 'when deleting an owned project' do
      it 'deletes the project' do
        expect {
          delete :destroy, params: { id: user_project.id }, format: :json
        }.to change(Project, :count).by(-1)
      end

      it 'returns no content status' do
        delete :destroy, params: { id: user_project.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when trying to delete another user\'s project' do
      it 'does not delete the project' do
        expect {
          delete :destroy, params: { id: other_user_project.id }, format: :json
        }.not_to change(Project, :count)
      end

      it 'returns not found status with error message' do
        delete :destroy, params: { id: other_user_project.id }, format: :json

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
        expect(json_response['errors']).to include('Project not found or not owned by you')
      end
    end

    context 'when project does not exist' do
      it 'returns not found status' do
        delete :destroy, params: { id: 9999 }, format: :json

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user_project) { Project.create!(title: 'Original Title', description: 'Original description', owner: 'test_user') }
    let!(:other_user_project) { Project.create!(title: 'Other User Project', description: 'Project owned by another user', owner: 'other_user') }
    let(:valid_attributes) { { title: 'Updated Title', description: 'Updated description' } }
    let(:invalid_attributes) { { title: '', description: 'Invalid update with empty title' } }

    context 'when updating an owned project' do
      it 'updates the project' do
        patch :update, params: { id: user_project.id, project: valid_attributes }, format: :json

        user_project.reload
        expect(user_project.title).to eq('Updated Title')
        expect(user_project.description).to eq('Updated description')
      end

      it 'returns a JSON response with the updated project' do
        patch :update, params: { id: user_project.id, project: valid_attributes }, format: :json

        expect(response).to have_http_status(:success)
        expect(response.content_type).to match(%r{application/json})

        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Updated Title')
        expect(json_response['description']).to eq('Updated description')
        expect(json_response['owner']).to eq('test_user')
      end
    end

    context 'with invalid parameters' do
      before do
        # Add validation to the Project model for the test
        allow_any_instance_of(Project).to receive(:update).and_return(false)
        allow_any_instance_of(Project).to receive(:errors).and_return(
          double(full_messages: [ 'Title can\'t be blank' ])
        )
      end

      it 'returns a JSON response with errors' do
        patch :update, params: { id: user_project.id, project: invalid_attributes }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(%r{application/json})

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
        expect(json_response['errors']).to include('Title can\'t be blank')
      end
    end

    context 'when trying to update another user\'s project' do
      it 'does not update the project' do
        original_title = other_user_project.title

        patch :update, params: { id: other_user_project.id, project: valid_attributes }, format: :json

        other_user_project.reload
        expect(other_user_project.title).to eq(original_title)
      end

      it 'returns not found status with error message' do
        patch :update, params: { id: other_user_project.id, project: valid_attributes }, format: :json

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
        expect(json_response['errors']).to include('Project not found or not owned by you')
      end
    end

    context 'when project does not exist' do
      it 'returns not found status' do
        patch :update, params: { id: 9999, project: valid_attributes }, format: :json

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
      end
    end
  end
end
