import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import Home from './page';

// Mock the next/image component
vi.mock('next/image', () => ({
    default: ({ src, alt }: { src: string; alt: string }) => (
        // eslint-disable-next-line @next/next/no-img-element
        <img src={src} alt={alt} />
    ),
}));

describe('Home', () => {
    it('renders the page with Next.js logo', () => {
        render(<Home />);

        // Check if the Next.js logo is present
        const logoElement = screen.getByAltText('Next.js logo');
        expect(logoElement).toBeInTheDocument();
    });

    it('renders the "Get started" text', () => {
        render(<Home />);

        // Check if the get started text is present
        const getStartedText = screen.getByText(/Get started by editing/i);
        expect(getStartedText).toBeInTheDocument();
    });
});