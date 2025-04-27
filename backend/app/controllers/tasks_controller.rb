class TasksController < ApplicationController
    def tasks_without_deadline
        owner = current_user
        @pending_tasks = Task.where(deadline: nil, project_id: nil, done: false, owner: owner).order(created_at: :desc).select(:title, :done)
        @completed_tasks = Task.where(deadline: nil, project_id: nil, done: true, owner: owner).order(created_at: :desc).select(:title, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end

    def tasks_with_deadline_today
        today = Date.today
        owner = current_user

        @pending_tasks = Task.where(deadline: today, done: false, owner: owner).order(created_at: :desc).select(:title, :deadline, :done)
        @completed_tasks = Task.where(deadline: today, done: true, owner: owner).order(created_at: :desc).select(:title, :deadline, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end

    def tasks_with_deadline_this_week
        owner = current_user
        start_of_week = Date.today.beginning_of_week
        end_of_week = Date.today.end_of_week

        @pending_tasks = Task.where(deadline: start_of_week..end_of_week, done: false, owner: owner).order(deadline: :asc).select(:title, :deadline, :done)
        @completed_tasks = Task.where(deadline: start_of_week..end_of_week, done: true, owner: owner).order(deadline: :asc).select(:title, :deadline, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end

    def tasks_for_project
        owner = current_user
        project_id = params.require(:project_id)

        @pending_tasks = Task.where(project_id: project_id, done: false, owner: owner).order(created_at: :desc).select(:title, :done)
        @completed_tasks = Task.where(project_id: project_id, done: true, owner: owner).order(created_at: :desc).select(:title, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end
end
