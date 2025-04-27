class TasksController < ApplicationController
    def tasks_without_deadline
        @pending_tasks = Task.where(deadline: nil, project_id: nil, done: false).order(created_at: :desc).select(:title, :done)
        @completed_tasks = Task.where(deadline: nil, project_id: nil, done: true).order(created_at: :desc).select(:title, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end

    def tasks_with_deadline_today
        today = Date.today

        @pending_tasks = Task.where(deadline: today, done: false).order(created_at: :desc).select(:title, :deadline, :done)
        @completed_tasks = Task.where(deadline: today, done: true).order(created_at: :desc).select(:title, :deadline, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end

    def tasks_with_deadline_this_week
        start_of_week = Date.today.beginning_of_week
        end_of_week = Date.today.end_of_week

        @pending_tasks = Task.where(deadline: start_of_week..end_of_week, done: false).order(deadline: :asc).select(:title, :deadline, :done)
        @completed_tasks = Task.where(deadline: start_of_week..end_of_week, done: true).order(deadline: :asc).select(:title, :deadline, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end

    def tasks_for_project
        project_id = params.require(:project_id)
        @pending_tasks = Task.where(project_id: project_id, done: false).order(created_at: :desc).select(:title, :done)
        @completed_tasks = Task.where(project_id: project_id, done: true).order(created_at: :desc).select(:title, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end
end
