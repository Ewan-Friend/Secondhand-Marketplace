# Stage 1: Build the Flutter Web assets
FROM debian:bookworm-slim AS build-env

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa wget \
    && rm -rf /var/lib/apt/lists/*

# Clone the LATEST stable Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run doctor to download the latest Dart SDK (will be 3.9+ in 2026)
RUN flutter doctor -v

WORKDIR /app
COPY . .

# Build the web project
RUN flutter pub get
RUN flutter build web --release --dart-define=API_BASE_URL=/api

# Stage 2: Serve the files with Nginx
FROM nginx:alpine
# Copy the compiled files from the build stage to Nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html
# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]