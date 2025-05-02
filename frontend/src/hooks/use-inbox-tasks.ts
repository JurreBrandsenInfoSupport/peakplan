import { fetchInboxTasks } from "@/lib/api";
import useSWR from "swr";

export default function useInboxTasks() {
  const { data, mutate, error, isLoading } = useSWR(
    "/api/tasks/inbox",
    fetchInboxTasks,
  );

  return {
    tasks: data,
    mutate,
    error,
    isLoading,
  };
}
