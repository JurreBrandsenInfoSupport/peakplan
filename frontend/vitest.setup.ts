// Global test setup for Vitest
import "@testing-library/react";
import "@testing-library/jest-dom";
import { vi, beforeEach } from "vitest";

// Add any global test setup here
// For example, you might want to extend expect with custom matchers

// Reset all mocks before each test
beforeEach(() => {
  vi.resetAllMocks();
});
