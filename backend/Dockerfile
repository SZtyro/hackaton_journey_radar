# Stage 1: Build the application using a Maven image
# This image already has Maven and the JDK, so we don't need to install it.
FROM maven:3.8-openjdk-17 AS builder

WORKDIR /app
# Copy only the pom.xml first to leverage Docker layer caching
COPY pom.xml .
# Download dependencies
RUN mvn dependency:go-offline

# Copy the rest of the source code and build the executable JAR
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the final, small image using only the Java Runtime
FROM openjdk:17-jre-slim

WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Tell Render what port the application will run on
EXPOSE 8080

# The command to run the self-contained application
ENTRYPOINT ["java", "-jar", "app.jar"]