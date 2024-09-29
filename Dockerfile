# Use Ruby base image
FROM ruby:3.0.3

# Install Node.js and Yarn
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs curl

# Install the correct Yarn version (>=1 and <4)
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn=1.*

# Install the correct Bundler version
RUN gem install bundler:2.3.13

# Create a non-root user
RUN useradd -m appuser
USER appuser

# Set working directory
WORKDIR /app

# Set a local path for gems to avoid permission issues
ENV GEM_HOME="/app/vendor/bundle"
ENV BUNDLE_PATH="$GEM_HOME"
ENV BUNDLE_BIN="$GEM_HOME/bin"
ENV PATH="$BUNDLE_BIN:$PATH"

# Set Node.js options for legacy OpenSSL
ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy Gemfile and install gems
COPY --chown=appuser:appuser Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the app code
COPY --chown=appuser:appuser . .

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose the Rails port
EXPOSE 3000

# Start Rails server
CMD rails server -b 0.0.0.0
