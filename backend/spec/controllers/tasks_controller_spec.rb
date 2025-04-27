require 'rails_helper'

describe TasksController, type: :controller do
  describe 'GET #tasks_with_deadline_today' do
    let!(:project) { Project.create!(title: 'Test Project', description: 'A sample project') }
    let!(:pending_task) { Task.create!(title: 'Pending Task', done: false, deadline: Date.today, project_id: nil) }
    let!(:completed_task) { Task.create!(title: 'Completed Task', done: true, deadline: Date.today, project_id: project.id) }
    let!(:other_task) { Task.create!(title: 'Other Task', done: false, deadline: Date.today - 1, project_id: project.id) }

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
  let!(:project) { Project.create!(title: 'Test Project', description: 'A sample project') }
    let!(:pending_task) { Task.create!(title: 'Pending Task', done: false, deadline: nil, project_id: nil) }
    let!(:completed_task) { Task.create!(title: 'Completed Task', done: true, deadline: nil, project_id: nil) }
    let!(:other_task) { Task.create!(title: 'Other Task', done: false, deadline: Time.now, project_id: project.id) }

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
    let!(:pending_task_this_week) { Task.create!(title: 'Pending Task This Week', done: false, deadline: Date.today.beginning_of_week + 1.day) }
    let!(:completed_task_this_week) { Task.create!(title: 'Completed Task This Week', done: true, deadline: Date.today.beginning_of_week + 2.days) }
    let!(:task_outside_this_week) { Task.create!(title: 'Task Outside This Week', done: false, deadline: Date.today.beginning_of_week - 1.day) }

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
    let!(:project) { Project.create!(title: 'Test Project', description: 'A sample project') }
    let!(:pending_task) { Task.create!(title: 'Pending Task', done: false, project_id: project.id) }
    let!(:completed_task) { Task.create!(title: 'Completed Task', done: true, project_id: project.id) }
    let!(:other_task) { Task.create!(title: 'Other Task', done: false, project_id: nil) }

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
end
