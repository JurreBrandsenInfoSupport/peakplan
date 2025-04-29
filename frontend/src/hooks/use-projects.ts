import { ProjectSummary } from "@/lib/types";
import useSWR from "swr";

function fetcher<T>(input: RequestInfo | URL, init?: RequestInit): Promise<T> {
  return fetch(input, init).then(async (res) => {
    if (!res.ok) {
      const errorData = await res.json();

      throw new Error(
        errorData.error || "An error occurred while fetching data"
      );
    }
    return res.json();
  });
}

export default function useProjects() {
  const { data, error, isLoading } = useSWR(
    "/api/projects",
    fetcher<ProjectSummary[]>
  );

  return {
    projects: data,
    isLoading,
    error,
  };
}
