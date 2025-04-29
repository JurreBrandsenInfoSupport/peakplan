import { ProjectSummary } from "@/lib/types";
import useSWR from "swr";

function fetchWithToken(input: RequestInfo | URL, token?: string, init?: RequestInit) {
  return fetch(input, {
    ...init,
    headers: {
      ...init?.headers,
      "Authorization": `Bearer ${token}`
    }
  }).then(async (res) => {
    if (!res.ok) {
      const error = await res.json();
      throw new Error(error.message);
    }

    return await res.json();
  });
}

export default function useProjects(token?: string) {
  const { data, error, isLoading, mutate } = useSWR(
    ["/api/projects", token],([url, token]) => fetchWithToken(url, token)
  );

  return {
    projects: data,
    isLoading,
    error,
    mutate
  };
}
