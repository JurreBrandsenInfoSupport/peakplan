import { describe, it, expect, vi } from 'vitest';
import { fireEvent, render } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import TaskList from './task-list';
import { Task } from '@/lib/types';

describe('TaskList', () => {
    // Common handlers and setup
    const handleMarkTaskCompleted = vi.fn();
    const handleMarkTaskPending = vi.fn();
    const handleCreateTask = vi.fn();

    const samplePendingTask = {
        id: 1,
        title: 'test',
        description: '',
        deadline: new Date(2025, 1, 1),
        done: false
    };

    const sampleCompletedTask = { ...samplePendingTask, done: true };

    // Helper function to render the component
    const renderTaskList = (pendingTasks: Task[], completedTasks: Task[]) => {
        return render(<TaskList
            completedTasks={completedTasks}
            pendingTasks={pendingTasks}
            onMarkTaskCompleted={handleMarkTaskCompleted}
            onMarkTaskPending={handleMarkTaskPending}
            onCreateTask={handleCreateTask} />);
    };

    it('Renders pending tasks correctly', () => {
        const pendingTasks = [samplePendingTask];
        const completedTasks: Task[] = [];

        const component = renderTaskList(pendingTasks, completedTasks);
        expect(component).toMatchSnapshot();
    });

    it('Renders completed tasks correctly', () => {
        const pendingTasks: Task[] = [];
        const completedTasks = [sampleCompletedTask];

        const component = renderTaskList(pendingTasks, completedTasks);
        expect(component).toMatchSnapshot();
    });

    it('Marks tasks as pending correctly', () => {
        const pendingTasks: Task[] = [];
        const completedTasks = [sampleCompletedTask];

        const component = renderTaskList(pendingTasks, completedTasks);
        fireEvent.click(component.getByRole('checkbox'));

        expect(handleMarkTaskPending).toBeCalled();
    });

    it('Marks tasks as completed correctly', () => {
        const pendingTasks = [samplePendingTask];
        const completedTasks: Task[] = [];

        const component = renderTaskList(pendingTasks, completedTasks);
        fireEvent.click(component.getByRole('checkbox'));

        expect(handleMarkTaskCompleted).toBeCalled();
    });

    it('Creates a new task when the form for it submitted', async () => {
        const pendingTasks: Task[] = [];
        const completedTasks: Task[] = [];

        const user = userEvent.setup();
        const component = renderTaskList(pendingTasks, completedTasks);

        // Expand the create task form first.
        const expandButton = component.getByText('Add new task');
        await user.click(expandButton);

        // Next, input the values into the form, and submit it.
        const titleInput = component.getByPlaceholderText('Task title');
        const submitButton = component.getByText('Create Task');

        await user.type(titleInput, 'Test task');
        await user.click(submitButton);

        expect(handleCreateTask).toBeCalledWith("Test task", "", undefined);
    })
});