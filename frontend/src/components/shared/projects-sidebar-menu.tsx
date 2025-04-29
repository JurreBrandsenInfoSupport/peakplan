"use client";

import useProjects from "@/hooks/use-projects";
import Link from "next/link";
import { SidebarMenu, SidebarMenuButton, SidebarMenuItem } from "../ui/sidebar";
import { Skeleton } from "../ui/skeleton";

function LoadingProjects() {
  return (
    <>
      <SidebarMenuItem className="p-2">
        <SidebarMenuButton asChild>
          <Skeleton />
        </SidebarMenuButton>
      </SidebarMenuItem>
      <SidebarMenuItem className="p-2">
        <SidebarMenuButton asChild>
          <Skeleton />
        </SidebarMenuButton>
      </SidebarMenuItem>
      <SidebarMenuItem className="p-2">
        <SidebarMenuButton asChild>
          <Skeleton />
        </SidebarMenuButton>
      </SidebarMenuItem>
    </>
  );
}

export default function ProjectsSidebarMenu() {
  const { projects, error, isLoading } = useProjects();

  return (
    <SidebarMenu>
      {projects &&
        projects.map((project) => (
          <SidebarMenuItem key={project.id}>
            <SidebarMenuButton asChild>
              <Link href={`/projects/${project.id}`}>{project.title}</Link>
            </SidebarMenuButton>
          </SidebarMenuItem>
        ))}
      {isLoading && <LoadingProjects />}
      {!projects ||
        (projects.length === 0 && (
          <SidebarMenuItem>
            <span className="p-2 text-muted-foreground">
              No projects yet...
            </span>
          </SidebarMenuItem>
        ))}
      {error && (
        <SidebarMenuItem>
          <span className="p-2 text-muted-foreground">
            Failed to load projects.
          </span>
        </SidebarMenuItem>
      )}
    </SidebarMenu>
  );
}
