FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=${RAILWAY_SQL_PASSWORD}
ENV MSSQL_PID=Express
ENV PORT=1433

RUN mkdir -p /var/opt/mssql/data && \
    chmod -R 777 /var/opt/mssql/data

USER mssql

EXPOSE ${PORT}

HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=3 \
    CMD /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${RAILWAY_SQL_PASSWORD} -Q "SELECT 1" || exit 1