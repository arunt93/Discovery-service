# Use Java 17 as base image
FROM amazoncorretto:17-alpine

# Set working directory
WORKDIR /app

# Copy the built JAR file
COPY target/discovery-server-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8761 (Eureka default port)
EXPOSE 8761

# Run the application
CMD ["java", "-jar", "app.jar"]
