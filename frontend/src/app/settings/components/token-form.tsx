"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { useForm } from "react-hook-form"
import { z } from "zod"
import { useAuthStore } from "@/store/authStore"
import { Button } from "@/components/ui/button"
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import useProjects from "@/hooks/use-projects"

const tokenFormSchema = z.object({
  token: z.string().min(1, "Token is required"),
})

type TokenFormValues = z.infer<typeof tokenFormSchema>

export function TokenForm() {
  const token = useAuthStore(state => state.token);
  const { mutate: mutateProjects } = useProjects(token);
  
  const form = useForm<TokenFormValues>({
    resolver: zodResolver(tokenFormSchema),
    defaultValues: {
      token: "",
    },
  })

  const { setToken } = useAuthStore()

  function onSubmit(data: TokenFormValues) {
    setToken(data.token.trim())
    mutateProjects();
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="token"
          render={({ field }) => (
            <FormItem>
              <FormLabel>API Token</FormLabel>
              <FormControl>
                <Input type="password" placeholder="Enter your API token" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button type="submit">Save</Button>
      </form>
    </Form>
  )
}
