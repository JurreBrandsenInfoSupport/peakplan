import { fetchProjectTasks } from "@/lib/api";
import useSWR from "swr";

export default function useProjectTasks(projectId: number) {
  const { data, error, isLoading, mutate } = useSWR(
    `/api/projects/${projectId}/tasks`,
    () => fetchProjectTasks(projectId)
  );

  return {
    tasks: data,
    error,
    isLoading,
    mutate,
  };
}
