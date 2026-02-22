# Build stage
FROM maven:3.8.4-amazoncorretto-17 AS build

WORKDIR /app

# Copy pom.xml first for better layer caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM amazoncorretto:17-alpine

# Install curl for health checks
RUN apk add --no-cache curl

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/discovery-server-0.0.1-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8761

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8761/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
