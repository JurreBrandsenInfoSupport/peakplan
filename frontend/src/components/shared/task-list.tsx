import { Task } from "@/lib/types";
import { ColumnDef } from "@tanstack/react-table";
import { ChevronsUpDown, Plus } from "lucide-react";
import { useEffect, useState } from "react";
import { Button } from "../ui/button";
import { Checkbox } from "../ui/checkbox";
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "../ui/collapsible";
import CreateTaskForm from "./create-task-form";
import { DataTable } from "./data-table";

interface TaskListProps {
  pendingTasks: Task[];
  completedTasks: Task[];
  onCreateTask: (
    title: string,
    description: string,
    deadline?: Date
  ) => Promise<void>;
  onMarkTaskCompleted: (taskId: number) => Promise<void>;
  onMarkTaskPending: (taskId: number) => Promise<void>;
}

export default function TaskList(props: TaskListProps) {
  const [showCompletedTasks, setShowCompletedTasks] = useState(false);
  const [showCreateTask, setShowCreateTask] = useState(false);

  useEffect(() => {
    if (props.pendingTasks.length === 0 && props.completedTasks.length > 0) {
      setShowCompletedTasks(true);
    }
  }, [props.pendingTasks.length, props.completedTasks.length]);

  const formatDate = (date: string | Date | null | undefined) => {
    if (!date) return "";
    return new Date(date).toLocaleDateString();
  };

  const pendingColumns: ColumnDef<Task>[] = [
    {
      accessorKey: "done",
      header: undefined,
      cell: ({ row }) => (
        <Checkbox
          checked={row.original.done}
          onCheckedChange={() => props.onMarkTaskCompleted(row.original.id)}
        />
      ),
      meta: {
        className: "w-16",
      },
    },
    {
      accessorKey: "title",
      header: "Title",
    },
    {
      accessorKey: "deadline",
      header: "Deadline",
      cell: ({ row }) => formatDate(row.original.deadline),
      meta: {
        className: "w-64",
      },
    },
  ];

  const completedColumns: ColumnDef<Task>[] = [
    {
      accessorKey: "done",
      cell: ({ row }) => (
        <Checkbox
          checked={row.original.done}
          onCheckedChange={() => props.onMarkTaskPending(row.original.id)}
        />
      ),
      header: undefined,
      meta: {
        className: "w-16",
      },
    },
    {
      accessorKey: "title",
      header: "Title",
    },
    {
      accessorKey: "deadline",
      header: "Deadline",
      cell: ({ row }) => formatDate(row.original.deadline),
      meta: {
        className: "w-64",
      },
    },
  ];

  const handleCreateTask = async (data: {
    title: string;
    description: string;
    deadline?: Date;
  }) => {
    await props.onCreateTask(data.title, data.description, data.deadline);
    setShowCreateTask(false);
  };

  return (
    <>
      {props.pendingTasks.length > 0 ? (
        <DataTable columns={pendingColumns} data={props.pendingTasks} />
      ) : (
        <div className="py-4 text-center text-muted-foreground font-medium">
          Hurray, no pending tasks
        </div>
      )}
      <Collapsible open={showCreateTask} onOpenChange={setShowCreateTask} className="mt-4">
        <CollapsibleTrigger asChild>
          <Button variant="ghost" className="w-full flex flex-row">
            <Plus /> Add new task
          </Button>
        </CollapsibleTrigger>
        <CollapsibleContent className="mt-4">
          <CreateTaskForm onCreateTask={handleCreateTask} />
        </CollapsibleContent>
      </Collapsible>
      <Collapsible
        open={showCompletedTasks}
        onOpenChange={setShowCompletedTasks}
      >
        <CollapsibleTrigger asChild>
          <div className="w-full flex flex-row">
            <h2 className="font-semibold text-xl">Completed tasks</h2>
            <ChevronsUpDown className="ml-auto"></ChevronsUpDown>
          </div>
        </CollapsibleTrigger>
        <CollapsibleContent className="pt-4">
          <DataTable columns={completedColumns} data={props.completedTasks} />
        </CollapsibleContent>
      </Collapsible>
    </>
  );
}
