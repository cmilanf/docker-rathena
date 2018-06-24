@ECHO OFF
REM Simple build script using a temp directory
REM %1 - Docker image name
REM %2 - (Optional) Additional build options (ex. --no-cache)
MD %TEMP%\docker-build
COPY /Y ..\*.* %TEMP%\docker-build
docker build %2 -t %1 %TEMP%\docker-build
RD /S /Q %TEMP%\docker-build