FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

COPY . .

RUN mvn -f "proyecto firewall/pom.xml" clean package -DskipTests
RUN mkdir /jars \
    && cp "proyecto firewall/eureka-service/target"/eureka-service-*.jar /jars/eureka-service.jar \
    && cp "proyecto firewall/usuarios/target"/ms-usuarios-*.jar /jars/ms-usuarios.jar \
    && cp "proyecto firewall/reportes/target"/ms-reportes-*.jar /jars/ms-reportes.jar \
    && cp "proyecto firewall/geolocalizacion/target"/geolocalizacion-*.jar /jars/ms-geolocalizacion.jar \
    && cp "proyecto firewall/alertas/target"/firewall-alerta-*.jar /jars/ms-alertas.jar \
    && cp "proyecto firewall/api-gateway/target"/api-gateway-*.jar /jars/api-gateway.jar

FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder /jars/eureka-service.jar /app/eureka-service.jar
COPY --from=builder /jars/ms-usuarios.jar /app/ms-usuarios.jar
COPY --from=builder /jars/ms-reportes.jar /app/ms-reportes.jar
COPY --from=builder /jars/ms-geolocalizacion.jar /app/ms-geolocalizacion.jar
COPY --from=builder /jars/ms-alertas.jar /app/ms-alertas.jar
COPY --from=builder /jars/api-gateway.jar /app/api-gateway.jar
COPY railway-start.sh /app/railway-start.sh
RUN chmod +x /app/railway-start.sh

EXPOSE 8080

ENTRYPOINT ["/app/railway-start.sh"]
