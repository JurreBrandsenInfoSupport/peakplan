# PeakPlan Backend

The backend for PeakPlan is built with Ruby on Rails, providing a robust API for the Next.js frontend.

## Prerequisites

- Ruby 3.2+ (Check exact version with `ruby -v`)
- PostgreSQL 14+
- Bundler (`gem install bundler`)
- Node.js and Yarn (for JavaScript dependencies)

## Environment Setup

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/peakplan.git
   cd peakplan/backend
   ```

2. Install dependencies:
   ```
   bundle install
   ```

## Database Setup

1. Create the database:

   ```
   bin/rails db:create
   ```

2. Run migrations:

   ```
   bin/rails db:migrate
   ```

3. Seed the database with sample data (optional):

   ```
   bin/rails db:seed
   ```

## Running the Application Locally

1. Start the Rails server:

   ```
   bin/rails server
   ```

   By default, the server will run on `http://localhost:3000`

2. For development with automatic reloading:
   ```
   bin/dev
   ```

## Running Tests

The project uses RSpec for testing. To run the test suite:

```
bundle exec rspec
```

To run specific tests:

```
bundle exec rspec spec/models/project_spec.rb
bundle exec rspec spec/controllers/tasks_controller_spec.rb
```

## Code Quality & Security

Run the following tools to ensure code quality and security:

1. RuboCop (code style):
   ```
   bin/rubocop
   ```

2. Brakeman (security vulnerabilities):

   ```
   bin/brakeman
   ```

## API Documentation

The API follows RESTful conventions and supports the following main endpoints:

- `/projects` - Project management
- `/tasks` - Task management

Detailed API documentation can be generated with:

```
# If using a documentation tool (e.g., Swagger)
bin/rails generate_api_docs
```

## Deployment

The application is configured for deployment with Kamal:

```
bundle exec kamal deploy
```

Refer to `config/deploy.yml` for deployment configuration details.

## Background Jobs

Background jobs are processed using Solid Queue. To start the worker:

```
bin/rails solid_queue:start
```

## Troubleshooting

- **Database connection issues**: Ensure PostgreSQL is running and credentials are correct in your `.env` file
- **JWT authentication errors**: Check that your JWT_SECRET is properly set

## Additional Resources

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [RSpec Documentation](https://rspec.info/documentation/)
- [JWT Documentation](https://github.com/jwt/ruby-jwt)
- [Kamal Deployment](https://kamal-deploy.org/)

## Project Structure

- `app/controllers/` - API controllers
- `app/models/` - Data models and business logic
- `app/jobs/` - Background jobs
- `config/routes.rb` - API route definitions
- `db/migrate/` - Database migrations
- `spec/` - Test suite
