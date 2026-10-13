# Multi-stage build for Java Gradle application
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Copy gradle files and source code
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./
COPY src src

# Make wrapper executable and package JAR
RUN chmod +x gradlew && ./gradlew jar --no-daemon

# Minimal runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
