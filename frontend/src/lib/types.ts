export interface ProjectSummary {
  id: number;
  title: string;
}

export interface ProjectDetails {
  id: number;
  title: string;
  description: string;
}

export interface TaskResponseData {
  completed: Task[];
  pending: Task[];
}

export interface Task {
  id: number;
  title: string;
  description: string;
  done: boolean;
  deadline?: string;
}
