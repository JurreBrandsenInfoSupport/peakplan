import { describe, it, expect } from 'vitest';
import { render } from '@testing-library/react';
import { DataTable } from './data-table';
import { ColumnDef } from '@tanstack/react-table';

describe('DataTable', () => {
    // Define test types
    type TestData = {
        id: number;
        name: string;
        email: string;
    };

    // Define test columns
    const columns: ColumnDef<TestData>[] = [
        {
            accessorKey: 'id',
            header: 'ID',
        },
        {
            accessorKey: 'name',
            header: 'Name',
        },
        {
            accessorKey: 'email',
            header: 'Email',
            meta: {
                className: 'hidden md:table-cell',
            },
        },
    ];

    // Define test data
    const data: TestData[] = [
        { id: 1, name: 'John Doe', email: 'john@example.com' },
        { id: 2, name: 'Jane Smith', email: 'jane@example.com' },
    ];

    // Helper function to render the component
    const renderDataTable = () => {
        return render(<DataTable columns={columns} data={data} />);
    };

    it('renders the table with data correctly', () => {
        const component = renderDataTable();
        expect(component).toMatchSnapshot();
    });

    it('renders empty state when no data is provided', () => {
        const component = render(<DataTable columns={columns} data={[]} />);
        expect(component).toMatchSnapshot();
    });

    it('renders with custom column classes', () => {
        const component = renderDataTable();
        expect(component).toMatchSnapshot();
    });
});