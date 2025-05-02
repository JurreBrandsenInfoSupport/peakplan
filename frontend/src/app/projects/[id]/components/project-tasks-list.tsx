"use client";

import TaskList from "@/components/shared/task-list";
import { Skeleton } from "@/components/ui/skeleton";
import useProjectTasks from "@/hooks/use-project-tasks";
import { createProjectTask, updateTaskStatus } from "@/lib/api";

interface ProjectTasksListProps {
  projectId: number;
}

export default function ProjectTasksList({ projectId }: ProjectTasksListProps) {
  const { tasks, mutate, isLoading } = useProjectTasks(projectId);

  async function markTaskCompleted(taskId: number) {
    console.log("Mark task as completed");
    await updateTaskStatus(taskId, true).then(() => mutate());
  }

  async function markTaskPending(taskId: number) {
    await updateTaskStatus(taskId, false).then(() => mutate());
  }

  async function createTask(
    title: string,
    description: string,
    deadline?: Date,
  ) {
    await createProjectTask(projectId, { title, description, deadline });
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
        onCreateTask={createTask}
        onMarkTaskCompleted={markTaskCompleted}
        onMarkTaskPending={markTaskPending}
      />
    </>
  );
}
