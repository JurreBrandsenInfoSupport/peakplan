require 'rails_helper'

describe TasksController, type: :controller do
  before do
    setup_authenticated_header
  end

  describe 'GET #tasks_with_deadline_today' do
    let!(:project) { Project.create!(title: 'Test Project', description: 'A sample project', owner: "test_user") }
    let!(:pending_task) { Task.create!(title: 'Pending Task', done: false, deadline: Date.today, project_id: nil, owner: "test_user") }
    let!(:completed_task) { Task.create!(title: 'Completed Task', done: true, deadline: Date.today, project_id: project.id, owner: "test_user") }
    let!(:other_task) { Task.create!(title: 'Other Task', done: false, deadline: Date.today - 1, project_id: project.id, owner: "test_user") }

    it 'returns tasks without a deadline and a project' do
      get :tasks_with_deadline_today, format: :json

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['pending'].size).to eq(1)
      expect(json_response['pending'].first['title']).to eq('Pending Task')
      expect(json_response['pending'].first['done']).to eq(false)

      expect(json_response['completed'].size).to eq(1)
      expect(json_response['completed'].first['title']).to eq('Completed Task')
      expect(json_response['completed'].first['done']).to eq(true)
    end
  end

  describe 'GET #tasks_without_deadline' do
  let!(:project) { Project.create!(title: 'Test Project', description: 'A sample project', owner: "test_user") }
    let!(:pending_task) { Task.create!(title: 'Pending Task', done: false, deadline: nil, project_id: nil, owner: "test_user") }
    let!(:completed_task) { Task.create!(title: 'Completed Task', done: true, deadline: nil, project_id: nil, owner: "test_user") }
    let!(:other_task) { Task.create!(title: 'Other Task', done: false, deadline: Time.now, project_id: project.id, owner: "test_user") }

    it 'returns tasks without a deadline and a project' do
      get :tasks_without_deadline, format: :json

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['pending'].size).to eq(1)
      expect(json_response['pending'].first['title']).to eq('Pending Task')
      expect(json_response['pending'].first['done']).to eq(false)

      expect(json_response['completed'].size).to eq(1)
      expect(json_response['completed'].first['title']).to eq('Completed Task')
      expect(json_response['completed'].first['done']).to eq(true)
    end
  end

  describe 'GET #tasks_with_deadline_this_week' do
    let!(:pending_task_this_week) { Task.create!(title: 'Pending Task This Week', done: false, deadline: Date.today.beginning_of_week + 1.day, owner: "test_user") }
    let!(:completed_task_this_week) { Task.create!(title: 'Completed Task This Week', done: true, deadline: Date.today.beginning_of_week + 2.days, owner: "test_user") }
    let!(:task_outside_this_week) { Task.create!(title: 'Task Outside This Week', done: false, deadline: Date.today.beginning_of_week - 1.day, owner: "test_user") }

    it 'returns tasks with deadlines within this week' do
      get :tasks_with_deadline_this_week, format: :json

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['pending'].size).to eq(1)
      expect(json_response['pending'].first['title']).to eq('Pending Task This Week')
      expect(json_response['pending'].first['done']).to eq(false)

      expect(json_response['completed'].size).to eq(1)
      expect(json_response['completed'].first['title']).to eq('Completed Task This Week')
      expect(json_response['completed'].first['done']).to eq(true)
    end
  end

  describe 'GET #tasks_for_project' do
    let!(:project) { Project.create!(title: 'Test Project', description: 'A sample project', owner: "test_user") }
    let!(:pending_task) { Task.create!(title: 'Pending Task', done: false, project_id: project.id, owner: "test_user") }
    let!(:completed_task) { Task.create!(title: 'Completed Task', done: true, project_id: project.id, owner: "test_user") }
    let!(:other_task) { Task.create!(title: 'Other Task', done: false, project_id: nil, owner: "test_user") }

    it 'returns tasks for a specific project' do
      get :tasks_for_project, params: { project_id: project.id }, format: :json

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['pending'].size).to eq(1)
      expect(json_response['pending'].first['title']).to eq('Pending Task')
      expect(json_response['pending'].first['done']).to eq(false)

      expect(json_response['completed'].size).to eq(1)
      expect(json_response['completed'].first['title']).to eq('Completed Task')
      expect(json_response['completed'].first['done']).to eq(true)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { task: { title: 'New Task', description: 'Task description', deadline: 1.day.from_now } } }

      it 'creates a new task' do
        expect {
          post :create, params: valid_params, format: :json
        }.to change(Task, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_params, format: :json
        expect(response).to have_http_status(:created)
      end

      it 'sets the current user as the owner' do
        post :create, params: valid_params, format: :json
        expect(Task.last.owner).to eq('test_user')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { task: { description: 'Task without title' } } }

      it 'does not create a new task' do
        expect {
          post :create, params: invalid_params, format: :json
        }.not_to change(Task, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_params, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post :create, params: invalid_params, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Title can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    let!(:task) { Task.create!(title: 'Original Task', description: 'Original description', done: false, deadline: 3.days.from_now, owner: 'test_user') }
    let!(:other_user_task) { Task.create!(title: 'Other User Task', description: 'Task owned by another user', done: false, deadline: 3.days.from_now, owner: 'other_user') }

    context 'with valid parameters for own task' do
      let(:valid_params) { {
        id: task.id,
        task: {
          title: 'Updated Task',
          description: 'Updated description',
          done: true,
          deadline: 5.days.from_now
        }
      } }

      it 'updates the task' do
        patch :update, params: valid_params, format: :json

        task.reload
        expect(task.title).to eq('Updated Task')
        expect(task.description).to eq('Updated description')
        expect(task.done).to eq(true)
        expect(task.deadline.to_date).to eq(5.days.from_now.to_date)
      end

      it 'returns a success status' do
        patch :update, params: valid_params, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'updating only specific fields' do
      let(:partial_update_params) { {
        id: task.id,
        task: {
          title: 'Only Update Title'
        }
      } }

      it 'updates only the specified fields' do
        original_description = task.description
        original_deadline = task.deadline
        original_done = task.done

        patch :update, params: partial_update_params, format: :json

        task.reload
        expect(task.title).to eq('Only Update Title')
        expect(task.description).to eq(original_description)
        expect(task.deadline).to eq(original_deadline)
        expect(task.done).to eq(original_done)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { {
        id: task.id,
        task: {
          title: ''
        }
      } }

      it 'does not update the task' do
        original_title = task.title

        patch :update, params: invalid_params, format: :json

        task.reload
        expect(task.title).to eq(original_title)
      end

      it 'returns unprocessable entity status' do
        patch :update, params: invalid_params, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        patch :update, params: invalid_params, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Title can't be blank")
      end
    end

    context 'when attempting to update another user\'s task' do
      let(:other_user_params) { {
        id: other_user_task.id,
        task: {
          title: 'Trying to update other user task'
        }
      } }

      it 'does not update the task' do
        original_title = other_user_task.title

        patch :update, params: other_user_params, format: :json

        other_user_task.reload
        expect(other_user_task.title).to eq(original_title)
      end

      it 'returns forbidden status' do
        patch :update, params: other_user_params, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with non-existent task id' do
      let(:non_existent_params) { {
        id: 9999,
        task: {
          title: 'Task does not exist'
        }
      } }

      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          patch :update, params: non_existent_params, format: :json
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:task) { Task.create!(title: 'Task to Delete', description: 'This task will be deleted', done: false, deadline: 3.days.from_now, owner: 'test_user') }
    let!(:other_user_task) { Task.create!(title: 'Other User Task', description: 'Task owned by another user', done: false, deadline: 3.days.from_now, owner: 'other_user') }

    context 'when deleting own task' do
      it 'deletes the task' do
        expect {
          delete :destroy, params: { id: task.id }, format: :json
        }.to change(Task, :count).by(-1)
      end

      it 'returns a success status' do
        delete :destroy, params: { id: task.id }, format: :json
        expect(response).to have_http_status(:ok)
      end

      it 'returns a success message' do
        delete :destroy, params: { id: task.id }, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Task successfully deleted')
      end
    end

    context 'when attempting to delete another user\'s task' do
      it 'does not delete the task' do
        expect {
          delete :destroy, params: { id: other_user_task.id }, format: :json
        }.not_to change(Task, :count)
      end

      it 'returns forbidden status' do
        delete :destroy, params: { id: other_user_task.id }, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with non-existent task id' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          delete :destroy, params: { id: 9999 }, format: :json
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
