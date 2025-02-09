FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=${RAILWAY_SQL_PASSWORD}
ENV MSSQL_PID=Developer
ENV MSSQL_MEMORY_LIMIT_MB=2048
ENV MSSQL_TCP_PORT=${PORT}

RUN mkdir -p /var/opt/mssql/data && \
    chmod -R 777 /var/opt/mssql/data

USER mssql

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${RAILWAY_SQL_PASSWORD} -Q "SELECT 1" || exit 1