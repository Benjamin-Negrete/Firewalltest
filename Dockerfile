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

# Copy the build script and JAR finder
COPY copy-jar.sh .
RUN chmod +x copy-jar.sh

# Copy from builder and find JAR
COPY --from=builder /app /app-src
RUN bash -c 'find /app-src -name "api-gateway-*.jar" -exec cp {} /app.jar \;'

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app.jar"]
