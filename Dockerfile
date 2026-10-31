# Multi-stage build: the bundled Spring Boot app (Java 21) via the Maven wrapper.
# Replace this file if you use another runtime; keep the runtime rules below.
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
# Resolve dependencies first so they stay cached across source changes.
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN ./mvnw -q -B dependency:go-offline
COPY src src
RUN ./mvnw -q -B package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
# The platform runs the container as user 1000 (compute.user) with a read-only
# root filesystem where only /tmp is writable. Do the same here.
USER 1000
EXPOSE 8080
ENTRYPOINT ["java", "-Djava.io.tmpdir=/tmp", "-jar", "app.jar"]
