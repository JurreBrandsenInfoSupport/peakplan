require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it 'is valid with a title, description and owner' do
      project = Project.new(
        title: 'Test Project',
        description: 'This is a test project',
        owner: 'John Doe'
      )
      expect(project).to be_valid
    end

    it 'is invalid without an owner' do
      project = Project.new(
        title: 'Test Project',
        description: 'This is a test project',
        owner: nil
      )
      project.valid?
      expect(project.errors[:owner]).to include("can't be blank")
    end

    it 'is invalid without a title' do
      project = Project.new(
        title: nil,
        description: 'This is a test project',
        owner: 'John Doe'
      )
      project.valid?
      expect(project.errors[:title]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many tasks' do
      association = Project.reflect_on_association(:tasks)
      expect(association.macro).to eq :has_many
    end

    it 'destroys associated tasks when destroyed' do
      project = Project.create!(
        title: 'Test Project',
        description: 'This is a test project',
        owner: 'John Doe'
      )
      project.tasks.create!(
        title: 'Test Task',
        owner: 'John Doe'
      )
      expect { project.destroy }.to change { Task.count }.by(-1)
    end
  end

  describe 'basic functionality' do
    let(:project) do
      Project.create!(
        title: 'Test Project',
        description: 'This is a test project',
        owner: 'John Doe'
      )
    end

    it 'can add tasks' do
      task = project.tasks.create!(
        title: 'New Task',
        owner: 'John Doe'
      )
      expect(project.tasks).to include(task)
    end
  end
end
