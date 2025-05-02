"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useRouter } from "next/navigation";
import { useForm } from "react-hook-form";
import * as z from "zod";

import { Button } from "@/components/ui/button";
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import useProjects from "@/hooks/use-projects";
import { createProject } from "@/lib/api";

const projectFormSchema = z.object({
  title: z
    .string()
    .min(3, {
      message: "Title must be at least 3 characters.",
    })
    .max(100, {
      message: "Title must not exceed 100 characters.",
    }),
  description: z.string().max(1000, {
    message: "Description must not exceed 1000 characters.",
  }),
});

type ProjectFormValues = z.infer<typeof projectFormSchema>;

export default function NewProjectPage() {
  const router = useRouter();
  const { projects, mutate: mutateProjects } = useProjects();

  const form = useForm<ProjectFormValues>({
    resolver: zodResolver(projectFormSchema),
    defaultValues: {
      title: "",
      description: "",
    },
  });

  async function onSubmit(data: ProjectFormValues) {
    try {
      const createdProject = await createProject(data.title, data.description);

      if (!projects) {
        mutateProjects([
          { id: createdProject.id, title: createdProject.title },
        ]);
      } else {
        const newProjects = [
          ...projects,
          { id: createdProject.id, title: data.title },
        ].sort((a, b) => a.title.localeCompare(b.title));

        mutateProjects(newProjects);

        router.push(`/projects/${createdProject.id}`);
      }
    } catch (error) {
      console.error("Error creating project:", error);
    }
  }

  return (
    <div className="container mx-auto py-10 px-8">
      <h1 className="text-2xl font-bold mb-6">Create New Project</h1>

      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
          <FormField
            control={form.control}
            name="title"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Project Title</FormLabel>
                <FormControl>
                  <Input placeholder="Enter project title" {...field} />
                </FormControl>
                <FormDescription>
                  Give your project a descriptive title.
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="description"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Description</FormLabel>
                <FormControl>
                  <Textarea
                    placeholder="Describe your project..."
                    className="resize-none h-32"
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  Provide details about the project&apos;s goals and scope.
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />

          <Button
            type="submit"
            disabled={form.formState.isSubmitting}
            className="w-full sm:w-auto"
          >
            {form.formState.isSubmitting ? "Creating..." : "Create Project"}
          </Button>
        </form>
      </Form>
    </div>
  );
}
