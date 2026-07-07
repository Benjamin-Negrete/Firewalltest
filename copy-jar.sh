#!/bin/bash
set -e

# Find and copy the API Gateway JAR
JAR=$(find /app/proyecto\ firewall/api-gateway/target -name "api-gateway-*.jar" | head -1)
if [ -z "$JAR" ]; then
  echo "API Gateway JAR not found!"
  ls -la /app/proyecto\ firewall/api-gateway/target/
  exit 1
fi

cp "$JAR" /app.jar
echo "Copied $JAR to /app.jar"
