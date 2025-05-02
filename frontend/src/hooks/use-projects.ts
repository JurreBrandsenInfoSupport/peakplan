import { fetchProjects } from "@/lib/api";
import useSWR from "swr";

export default function useProjects() {
  const { data, error, isLoading, mutate } = useSWR(
    "/api/projects",
    fetchProjects,
  );

  return {
    projects: data,
    isLoading,
    error,
    mutate,
  };
}
