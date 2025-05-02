# Custom Instructions for the PeakPlan Project

## Project Structure
- **Backend**: Located in the `backend/` folder. This is a Ruby on Rails project.
- **Frontend**: Located in the `frontend/` folder. This is a Next.js project.

## Backend (Ruby on Rails)

### Project specific instructions 

1. **Follow Rails Conventions**: Adhere to Rails conventions for file structure, naming, and coding style.
2. **Use Strong Parameters**: Always use strong parameters in controllers to prevent mass assignment vulnerabilities.
3. **Database Migrations**: Ensure all database changes are made through migrations and are properly version-controlled.
4. **Testing**: Write tests for controllers, models, and any custom logic using RSpec. Place tests in the appropriate `spec/` subdirectories.
5. **Security**: Use Rails' built-in security features, such as `filter_parameter_logging` for sensitive data and CSRF protection.
6. **Background Jobs**: Use Active Job for background processing and ensure jobs are idempotent.
7. **Logging**: Use Rails' logging framework and avoid logging sensitive information.
8. **Localization**: Use the `config/locales` directory for managing translations and ensure all user-facing text is localized.
9. **Code Quality**: Use tools like RuboCop and Brakeman to maintain code quality and security.
10. **Environment Configuration**: Store sensitive credentials securely using Rails' encrypted credentials feature.

### When modifying code in the backend

1. Always run specs from the backend directory after modifying files in the `spec/` directory to make sure the specs are valid.
2. Always verify `config/routes.rb` when modifying code in the `app/controllers` directory and update the routes as necessary.
3. Always generate a spec when you add new code to the `app/models`, or `app/controllers` directory.

## Frontend (Next.js)

### Project specific instructions 

1. **File-based Routing**: Use Next.js' file-based routing system and organize pages under the `src/app` directory.
2. **TypeScript**: Use TypeScript for type safety and better developer experience.
3. **CSS Modules**: Use CSS Modules or Tailwind CSS for styling to ensure scoped and maintainable styles.
4. **API Integration**: Use Next.js' built-in API routes for server-side logic or integrate with the Rails backend using REST or GraphQL.
5. **Static and Server-side Rendering**: Leverage static generation (SSG) and server-side rendering (SSR) where appropriate for performance and SEO.
6. **Environment Variables**: Use `.env.local` for environment-specific variables and avoid hardcoding sensitive information.
7. **Testing**: Write unit tests using vitest and integration tests with React Testing Library.
    * Place the tests side-by-side with the source files.
    * Use describe, it, expect from vitest when writing tests.
    * Use real implementations of external components instead of mocking
8. **Code Splitting**: Use dynamic imports to optimize performance and reduce initial load time.
9. **Accessibility**: Follow web accessibility standards (WCAG) and use tools like Axe for testing.
10. **Linting and Formatting**: Use ESLint and Prettier to maintain consistent code style and quality.

### When modifying code in the frontend

1. Always run the tests when you modify anything in the `src/` directory.
2. Always add tests for all modifications in the frontend. 