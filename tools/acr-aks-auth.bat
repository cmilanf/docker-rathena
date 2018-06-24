REM This small script grants Azure Kubernetes Service permissions into the Azure Container Registry 
FOR /F "tokens=*" %%F IN ('az aks show -g %1 -n %2 --query "servicePrincipalProfile.clientId" --output tsv') DO SET CLIENT_ID=%%F
FOR /F "tokens=*" %%F IN ('az acr show -g %3 -n %4 --query "id" --output tsv') DO SET ACR_ID=%%F
az role assignment create --assignee %CLIENT_ID% --role Reader --scope %ACR_ID%