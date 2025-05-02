import { render } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import CreateTaskForm from "./create-task-form";

describe("CreateTaskForm", () => {
  it("renders correctly", () => {
    const handleCreateTask = vi.fn(() => Promise.resolve());
    const component = render(
      <CreateTaskForm onCreateTask={handleCreateTask} />,
    );

    expect(component).toMatchSnapshot();
  });
});
