import { fetchTodaysTasks } from "@/lib/api";
import useSWR from "swr";

export default function useTodaysTasks() {
  const { data, mutate, error, isLoading } = useSWR(
    "/api/tasks/today",
    fetchTodaysTasks,
  );

  return {
    tasks: data,
    mutate,
    error,
    isLoading,
  };
}
