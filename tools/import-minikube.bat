@ECHO OFF
REM This small script import Docker images from local repository to minikube
SETLOCAL
REM For Windows
docker save %1 > %TEMP%\image.tar
FOR /F "tokens=*" %%i IN ('minikube docker-env') DO %%i
docker load -i %TEMP%\image.tar
DEL /F /Q %TEMP%\image.tar
ENDLOCAL
REM For UNIXes
REM docker save "${1}" | pv | (eval $(minikube docker-env) && docker load)