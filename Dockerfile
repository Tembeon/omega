# Use latest stable channel SDK to build the bot binary.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .
RUN dart compile exe bin/bot.dart -o bin/bot

# Build final image with sqlite3 libs and the compiled bot binary
FROM alpine:latest

# Install postgres and runtime dependencies
RUN apk add --no-cache postgresql postgresql-client

# TODO couldn't be bothered
WORKDIR /app
COPY --from=build /runtime/ /
COPY --from=build /app/bin/bot /app/bin/

# Start server.
COPY docker-entrypoint.sh /app/
CMD ["/app/docker-entrypoint.sh"]

