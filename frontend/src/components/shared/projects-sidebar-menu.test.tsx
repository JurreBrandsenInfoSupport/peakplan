import { describe, it, expect, vi, MockedFunction } from 'vitest';
import { render } from '@testing-library/react';
import ProjectsSidebarMenu from './projects-sidebar-menu';
import useProjects from '@/hooks/use-projects';
import { ProjectSummary } from '@/lib/types';
import { SidebarProvider } from '../ui/sidebar';

// Mock the useProjects hook
vi.mock('@/hooks/use-projects');

vi.mock('@/hooks/use-mobile', () => ({
    useIsMobile: () => false,
}));

const renderWithProviders = (component: React.ReactNode) => {
    return render(
        <SidebarProvider>
            {component}
        </SidebarProvider>
    );
};

describe('ProjectsSidebarMenu', () => {
    // Helper to mock the useProjects hook with different return values
    const mockUseProjects = (returnValue: {
        projects?: ProjectSummary[];
        isLoading?: boolean;
        error?: Error | null;
    }) => {
        (useProjects as MockedFunction<typeof useProjects>).mockReturnValue({
            projects: [],
            isLoading: false,
            error: null,
            mutate: vi.fn(),
            ...returnValue,
        });
    };

    it('should render loading skeletons when loading', () => {
        mockUseProjects({ isLoading: true });

        const component = renderWithProviders(<ProjectsSidebarMenu />);
        expect(component).toMatchSnapshot();
    });

    it('should render projects when loaded successfully', () => {
        const mockProjects: ProjectSummary[] = [
            { id: 1, title: 'Project A' },
            { id: 2, title: 'Project B' },
            { id: 3, title: 'Project C' },
        ];

        mockUseProjects({ projects: mockProjects });

        const component = renderWithProviders(<ProjectsSidebarMenu />);
        expect(component).toMatchSnapshot();
    });

    it('should display "No projects yet" message when projects array is empty', () => {
        mockUseProjects({ projects: [] });

        const component = renderWithProviders(<ProjectsSidebarMenu />);
        expect(component).toMatchSnapshot();
    });

    it('should display error message when there is an error', () => {
        mockUseProjects({ error: new Error('Failed to fetch') });

        const component = renderWithProviders(<ProjectsSidebarMenu />);
        expect(component).toMatchSnapshot();
    });
});