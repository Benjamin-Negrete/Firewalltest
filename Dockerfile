# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy pom files
COPY "proyecto firewall"/pom.xml ./pom.xml
COPY "proyecto firewall"/api-gateway ./api-gateway
COPY "proyecto firewall"/eureka-service ./eureka-service
COPY "proyecto firewall"/usuarios ./usuarios
COPY "proyecto firewall"/alertas ./alertas
COPY "proyecto firewall"/reportes ./reportes
COPY "proyecto firewall"/geolocalizacion ./geolocalizacion

# Build
RUN mvn clean install -DskipTests -pl api-gateway -am

# Stage 2: Runtime
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder /app/api-gateway/target/api-gateway-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
