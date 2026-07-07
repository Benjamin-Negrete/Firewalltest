# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy everything first
COPY . .

# Build only api-gateway
RUN mvn -f "proyecto firewall/pom.xml" clean install -DskipTests -pl api-gateway -am

# Stage 2: Runtime
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder "/app/proyecto firewall/api-gateway/target/api-gateway"*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
