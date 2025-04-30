"use client";

import { useProjectDetails } from "@/hooks/use-project-details";
import { useParams } from "next/navigation";

export default function ProjectDetailsPage() {
    const { id } = useParams<{ id: string }>();
    const { projectDetails } = useProjectDetails(id);

    return (
        <div className="container mx-auto py-10">
            <h1 className="text-2xl font-bold mb-6">{projectDetails?.title}</h1>
        </div>
    )
}