import {
  ProjectDetails,
  ProjectSummary,
  TaskResponseData as TaskListData,
} from "./types";

const backendUrl = "http://localhost:3000";

export class ApiError extends Error {
  status: number;

  constructor(message: string, status: number) {
    super(message);
    this.status = status;
    Object.setPrototypeOf(this, ApiError.prototype);
  }
}

function getApiHost() {
  if (typeof window !== "undefined") {
    return "/api";
  }

  return backendUrl;
}

async function processResponse<T>(response: Response): Promise<T> {
  if (response.status === 404) {
    throw new ApiError("Not found", 404);
  }

  if (!response.ok) {
    const errorText = await response.text();
    throw new ApiError(
      `Error: ${response.status} ${response.statusText} - ${errorText}`,
      response.status,
    );
  }

  return await response.json();
}

export async function fetchProject(id: string): Promise<ProjectDetails> {
  return fetch(`${getApiHost()}/projects/${id}`).then(
    processResponse<ProjectDetails>,
  );
}

export async function fetchProjects(): Promise<ProjectSummary[]> {
  return fetch(`${getApiHost()}/projects`).then(
    processResponse<ProjectSummary[]>,
  );
}

export async function fetchProjectTasks(
  projectId: number,
): Promise<TaskListData> {
  return fetch(`${getApiHost()}/projects/${projectId}/tasks`).then(
    processResponse<TaskListData>,
  );
}

export async function fetchInboxTasks() {
  return fetch(`${getApiHost()}/tasks/inbox`).then(
    processResponse<TaskListData>,
  );
}

export async function fetchTodaysTasks() {
  return fetch(`${getApiHost()}/tasks/today`).then(
    processResponse<TaskListData>,
  );
}

export async function fetchWeeklyTasks() {
  return fetch(`${getApiHost()}/tasks/this-week`).then(
    processResponse<TaskListData>,
  );
}

export async function createProject(title: string, description: string) {
  return await fetch(`${getApiHost()}/projects`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ title, description }),
  }).then(processResponse<ProjectDetails>);
}

export async function createProjectTask(
  projectId: number,
  data: { title: string; description: string; deadline?: Date },
) {
  return fetch(`${getApiHost()}/projects/${projectId}/tasks`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
  }).then(processResponse);
}

export async function updateTaskStatus(taskId: number, done: boolean) {
  return fetch(`${getApiHost()}/tasks/${taskId}`, {
    method: "PATCH",
    body: JSON.stringify({ done }),
    headers: {
      "Content-Type": "application/json",
    },
  });
}

export async function createTask({
  title,
  description,
  deadline,
}: {
  title: string;
  description: string;
  deadline?: Date;
}) {
  return fetch(`${getApiHost()}/tasks`, {
    method: "POST",
    body: JSON.stringify({ title, description, deadline }),
    headers: {
      "Content-Type": "application/json",
    },
  });
}
