require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'is valid with a title and owner' do
      task = Task.new(
        title: 'Test Task',
        owner: 'John Doe'
      )
      expect(task).to be_valid
    end

    it 'is invalid without a title' do
      task = Task.new(
        title: nil,
        owner: 'John Doe'
      )
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without an owner' do
      task = Task.new(
        title: 'Test Task',
        owner: nil
      )
      task.valid?
      expect(task.errors[:owner]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a project optionally' do
      association = Task.reflect_on_association(:project)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to eq true
    end
  end

  describe 'defaults' do
    it 'sets done to false by default' do
      task = Task.new(
        title: 'Test Task',
        owner: 'John Doe'
      )
      expect(task.done).to eq false
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

    it 'can be associated with a project' do
      task = Task.create!(
        title: 'Test Task',
        owner: 'John Doe',
        project: project
      )
      expect(task.project).to eq project
    end

    it 'can exist without a project' do
      task = Task.create!(
        title: 'Test Task',
        owner: 'John Doe',
        project: nil
      )
      expect(task.project).to be_nil
    end

    it 'can be marked as done' do
      task = Task.create!(
        title: 'Test Task',
        owner: 'John Doe'
      )
      task.update(done: true)
      expect(task.reload.done).to eq true
    end
  end
end