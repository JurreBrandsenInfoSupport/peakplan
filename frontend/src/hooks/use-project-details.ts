import { ProjectDetails } from "@/lib/types";
import useSWR from "swr";

export function useProjectDetails(id: string) {
    const fetchProjectDetails = async (projectId: string) => {
        const response = await fetch(`/api/projects/${projectId}`)
        const responseData = await response.json();

        if (!response.ok) {
            throw Error(responseData.error);
        }

        return responseData as ProjectDetails;
    }

    const { data, mutate, error } = useSWR(`/api/projects/${id}`, () => fetchProjectDetails(id));

    return {
        projectDetails: data,
        mutate,
        error
    }
}