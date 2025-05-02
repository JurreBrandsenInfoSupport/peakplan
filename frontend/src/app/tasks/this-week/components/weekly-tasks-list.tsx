"use client";

import TaskList from "@/components/shared/task-list";
import { Skeleton } from "@/components/ui/skeleton";
import useWeeklyTasks from "@/hooks/use-weekly-tasks";
import { createTask, updateTaskStatus } from "@/lib/api";

export default function WeeklyTasksList() {
  const { tasks, mutate, isLoading } = useWeeklyTasks();

  async function markTaskCompleted(taskId: number) {
    console.log("Mark task as completed");
    await updateTaskStatus(taskId, true).then(() => mutate());
  }

  async function markTaskPending(taskId: number) {
    await updateTaskStatus(taskId, false).then(() => mutate());
  }

  async function handleCreateTask(
    title: string,
    description: string,
    deadline?: Date,
  ) {
    await createTask({ title, description, deadline });
    mutate();
  }

  if (isLoading || !tasks) {
    return <Skeleton />;
  }

  return (
    <>
      <TaskList
        pendingTasks={tasks!.pending}
        completedTasks={tasks!.completed}
        onCreateTask={handleCreateTask}
        onMarkTaskCompleted={markTaskCompleted}
        onMarkTaskPending={markTaskPending}
      />
    </>
  );
}
