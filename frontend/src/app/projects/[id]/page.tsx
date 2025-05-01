import { ApiError, fetchProject } from "@/lib/api";
import { ProjectDetails } from "@/lib/types";
import { notFound } from "next/navigation";
import ProjectTasksList from "./components/project-tasks-list";

interface ProjectDetailsPageProps {
  params: Promise<{ id: string }>;
}

function ProjectDetailsError() {
  return (
    <div className="container mx-auto py-10 px-8">
      <h1 className="text-2xl font-bold mb-6">Error</h1>
      <p>Something went wrong while fetching the project details.</p>
    </div>
  );
}

interface ProjectDetailsPageContentProps {
  projectDetails: ProjectDetails;
}

function ProjectDetailsPageContent({
  projectDetails,
}: ProjectDetailsPageContentProps) {
  return (
    <div className="container mx-auto py-10 px-8 space-y-8 flex flex-col">
      <h1 className="text-2xl font-bold mb-6">{projectDetails.title}</h1>
      <ProjectTasksList projectId={projectDetails.id} />
    </div>
  );
}

export default async function ProjectDetailsPage({
  params,
}: ProjectDetailsPageProps) {
  const { id } = await params;

  try {
    const projectDetails = await fetchProject(id);

    return <ProjectDetailsPageContent projectDetails={projectDetails} />;
  } catch (error) {
    // Check if it's a 404 error
    if (error instanceof ApiError && error.status === 404) {
      return notFound();
    }

    // For all other errors, show the error component
    return <ProjectDetailsError />;
  }
}
