# Despliegue Railway + Vercel + Supabase

Este proyecto no usa Supabase directamente desde Angular. El flujo correcto es:

Vercel frontend -> Railway API Gateway -> microservicios Spring Boot -> Supabase Postgres

## 1. Railway

En Railway, abre el servicio `Firewalltest` y entra a `Variables`. Agrega estas variables:

```env
SPRING_PROFILES_ACTIVE=docker
SPRING_DATASOURCE_URL=jdbc:postgresql://HOST:PUERTO/postgres?sslmode=require
SPRING_DATASOURCE_USERNAME=USUARIO
SPRING_DATASOURCE_PASSWORD=PASSWORD

USUARIOS_SERVICE_URL=http://localhost:8084
REPORTES_SERVICE_URL=http://localhost:8081
GEO_SERVICE_URL=http://localhost:8083
ALERTAS_SERVICE_URL=http://localhost:8082
REPORTS_SERVICE_URL=http://localhost:8081/api/reportes/enviar
EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://localhost:8761/eureka/
```

En Supabase, los datos salen de `Project Settings` -> `Database` -> `Connection string`.

Para Supabase Pooler normalmente queda asi:

```env
SPRING_DATASOURCE_URL=jdbc:postgresql://aws-0-REGION.pooler.supabase.com:6543/postgres?sslmode=require
SPRING_DATASOURCE_USERNAME=postgres.PROJECT_REF
SPRING_DATASOURCE_PASSWORD=TU_PASSWORD_DE_BASE_DE_DATOS
```

Si usas la conexion directa de Supabase, normalmente el puerto es `5432` y el usuario suele ser `postgres`.

Despues de guardar variables, haz redeploy en Railway.

## 2. Vercel

El frontend ya apunta en produccion a:

```ts
https://firewalltest-production.up.railway.app
```

Si cambia el dominio de Railway, edita:

```text
firewall-web/src/environments/environment.prod.ts
```

Luego haz redeploy en Vercel.

## 3. Verificacion rapida

Despues del redeploy, prueba estas URLs:

```text
https://firewalltest-production.up.railway.app/api/usuarios/11111111-1
https://firewalltest-production.up.railway.app/api/reports
https://firewalltest-production.up.railway.app/api/geolocation
```

No es necesario que todas devuelvan datos. Lo importante es que no aparezca error de conexion a base de datos ni error 502/503.

## 4. Tablas en Supabase

Con `spring.jpa.hibernate.ddl-auto=update`, los microservicios crean tablas automaticamente cuando logran conectarse.

Si Supabase sigue mostrando "No tables or views", Railway todavia no esta usando las variables de Supabase o el backend no logro arrancar con Postgres.

## 5. Cambio importante aplicado

El microservicio de reportes antes usaba una tabla llamada `Usuario`, igual que el microservicio de usuarios, pero con columnas distintas. Eso genera conflictos en una sola base Postgres. Ahora reportes usa `reporte_usuario`, dejando `Usuario` para registro/login.
