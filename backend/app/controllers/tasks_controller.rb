class TasksController < ApplicationController
    def tasks_without_deadline
        owner = current_user
        @pending_tasks = Task.where(deadline: nil, project_id: nil, done: false, owner: owner).order(created_at: :desc).select(:id, :title, :deadline, :done)
        @completed_tasks = Task.where(deadline: nil, project_id: nil, done: true, owner: owner).order(created_at: :desc).select(:id, :title, :deadline, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end

    def tasks_with_deadline_today
        today = Date.today
        owner = current_user

        @pending_tasks = Task.where(deadline: today, done: false, owner: owner).order(created_at: :desc).select(:id, :title, :deadline, :done)
        @completed_tasks = Task.where(deadline: today, done: true, owner: owner).order(created_at: :desc).select(:id, :title, :deadline, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end

    def tasks_with_deadline_this_week
        owner = current_user
        start_of_week = Date.today.beginning_of_week
        end_of_week = Date.today.end_of_week

        @pending_tasks = Task.where(deadline: start_of_week..end_of_week, done: false, owner: owner).order(deadline: :asc).select(:id, :title, :deadline, :done)
        @completed_tasks = Task.where(deadline: start_of_week..end_of_week, done: true, owner: owner).order(deadline: :asc).select(:id, :title, :deadline, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end

    def tasks_for_project
        owner = current_user
        project_id = params.require(:project_id)

        @pending_tasks = Task.where(project_id: project_id, done: false, owner: owner).order(created_at: :desc).select(:id, :title, :deadline, :done)
        @completed_tasks = Task.where(project_id: project_id, done: true, owner: owner).order(created_at: :desc).select(:id, :title, :deadline, :done)

        render json: { pending: @pending_tasks, completed: @completed_tasks }
    end

    def create
        @task = Task.new(task_params)
        @task.owner = current_user

        if params[:project_id].present?
            @task.project_id = params[:project_id]
        end

        if @task.save
            render json: @task, status: :created
        else
            render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        @task = Task.find(params[:id])

        # Ensure user can only update their own tasks
        unless @task.owner == current_user
            return render json: { error: "Unauthorized" }, status: :forbidden
        end

        if params[:project_id].present?
            @project = Project.find(params[:project_id])

            # Ensure the task belongs to the specified project
            unless @task.project_id == @project.id
                return render json: { error: "Task does not belong to this project" }, status: :unprocessable_entity
            end
        end

        if @task.update(update_task_params)
            render json: @task, status: :ok
        else
            render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @task = Task.find(params[:id])

        # Ensure user can only remove their own tasks
        unless @task.owner == current_user
            return render json: { error: "Unauthorized" }, status: :forbidden
        end

        if params[:project_id].present?
            @project = Project.find(params[:project_id])

            # Ensure the task belongs to the specified project
            unless @task.project_id == @project.id
                return render json: { error: "Task does not belong to this project" }, status: :unprocessable_entity
            end
        end

        if @task.destroy
            render json: { message: "Task successfully deleted" }, status: :ok
        else
            render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def task_params
        params.require(:task).permit(:title, :description, :deadline, :project_id)
    end

    def update_task_params
        params.require(:task).permit(:title, :description, :deadline, :done)
    end
end
