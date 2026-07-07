#!/usr/bin/env sh
set -eu

export SPRING_PROFILES_ACTIVE="${SPRING_PROFILES_ACTIVE:-docker}"
export EUREKA_CLIENT_SERVICEURL_DEFAULTZONE="${EUREKA_CLIENT_SERVICEURL_DEFAULTZONE:-http://localhost:8761/eureka/}"
export USUARIOS_SERVICE_URL="${USUARIOS_SERVICE_URL:-http://localhost:8084}"
export REPORTES_SERVICE_URL="${REPORTES_SERVICE_URL:-http://localhost:8081}"
export REPORTS_SERVICE_URL="${REPORTS_SERVICE_URL:-http://localhost:8081/api/reportes/enviar}"
export GEO_SERVICE_URL="${GEO_SERVICE_URL:-http://localhost:8083}"
export ALERTAS_SERVICE_URL="${ALERTAS_SERVICE_URL:-http://localhost:8082}"

java -jar /app/eureka-service.jar &
sleep 12

java -jar /app/ms-usuarios.jar &
java -jar /app/ms-reportes.jar &
java -jar /app/ms-geolocalizacion.jar &
java -jar /app/ms-alertas.jar &
sleep 18

exec java -jar /app/api-gateway.jar
