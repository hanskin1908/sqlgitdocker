FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

# Configuración del sistema
RUN echo "fs.file-max=65535" >> /etc/sysctl.conf && \
    echo "fs.aio-max-nr=1048576" >> /etc/sysctl.conf

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=${RAILWAY_SQL_PASSWORD}
ENV MSSQL_PID=Developer
ENV MSSQL_TCP_PORT=${PORT}
ENV MSSQL_MEMORY_LIMIT_MB=2048
ENV MSSQL_TELEMETRY_ENABLED=FALSE

# Crear y configurar directorios
RUN mkdir -p /var/opt/mssql/data && \
    mkdir -p /var/opt/mssql/log && \
    mkdir -p /var/opt/mssql/secrets && \
    chmod -R 777 /var/opt/mssql

# Configurar límites de recursos
RUN echo "mssql soft nofile 65535" >> /etc/security/limits.conf && \
    echo "mssql hard nofile 65535" >> /etc/security/limits.conf

USER mssql

EXPOSE ${PORT}

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${RAILWAY_SQL_PASSWORD} -Q "SELECT 1" || exit 1