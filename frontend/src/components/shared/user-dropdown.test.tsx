import { expect, describe, it, vi } from "vitest";
import { render } from "@testing-library/react";
import UserDropdown from "./user-dropdown";
import { SidebarProvider } from "../ui/sidebar";

// Mock the next/navigation module
const pushMock = vi.fn();
vi.mock("next/navigation", () => ({
  useRouter: () => ({
    push: pushMock,
  }),
}));

// Mock the use-mobile hook to avoid mobile detection issues in tests
vi.mock("@/hooks/use-mobile", () => ({
  useIsMobile: () => false,
}));

const renderWithProviders = (component: React.ReactNode) => {
  return render(<SidebarProvider>{component}</SidebarProvider>);
};

describe("UserDropdown", () => {
  it("renders correctly", () => {
    const component = renderWithProviders(<UserDropdown />);
    expect(component).toMatchSnapshot();
  });
});
