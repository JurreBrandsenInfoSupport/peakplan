import { fetchWeeklyTasks } from "@/lib/api";
import useSWR from "swr";

export default function useWeeklyTasks() {
    const { data, mutate, error, isLoading } = useSWR(
        "/api/tasks/this-week",
        fetchWeeklyTasks,
    );

    return {
        tasks: data,
        mutate,
        error,
        isLoading,
    };
}
