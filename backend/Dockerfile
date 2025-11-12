FROM ruby:3.4

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client dos2unix && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Fix line endings for bin scripts
RUN find bin -type f -exec dos2unix {} \;

# Expose port
EXPOSE 3000

# Start the server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
