az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.OperationalInsights

RESOURCE_GROUP="keda-demo-rg"
LOCATION="eastus"
CONTAINERAPPS_ENVIRONMENT="keda-demo-acae"

az containerapp env create \
  --name $CONTAINERAPPS_ENVIRONMENT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

STORAGE_ACCOUNT_NAME="myacaenv20230307"

az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP \
  --location "$LOCATION" \
  --sku Standard_RAGRS \
  --kind StorageV2
#storageAccountConnectionString
STORAGE_ACCOUNT_CONNECTION_STRING=`az storage account show-connection-string -g $RESOURCE_GROUP --name $STORAGE_ACCOUNT_NAME --query connectionString --out json | tr -d '"'`

az storage queue create \
  --name 'myqueue' \
  --account-name $STORAGE_ACCOUNT_NAME \
  --connection-string $STORAGE_ACCOUNT_CONNECTION_STRING

az storage message put \
  --content "Hello Queue Reader App" \
  --queue-name "myqueue" \
  --connection-string $STORAGE_ACCOUNT_CONNECTION_STRING

az deployment group create --resource-group "$RESOURCE_GROUP" \
  --template-file ./queue.json \
  --parameters \
    environment_name="$CONTAINERAPPS_ENVIRONMENT" \
    queueconnection="$STORAGE_ACCOUNT_CONNECTION_STRING" \
    location="$LOCATION"

LOG_ANALYTICS_WORKSPACE_CLIENT_ID=`az containerapp env show --name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP --query properties.appLogsConfiguration.logAnalyticsConfiguration.customerId --out tsv`

az monitor log-analytics query \
  --workspace $LOG_ANALYTICS_WORKSPACE_CLIENT_ID \
  --analytics-query "ContainerAppConsoleLogs_CL | where ContainerAppName_s == 'queuereader' and Log_s contains 'Message ID' | project Time=TimeGenerated, AppName=ContainerAppName_s, Revision=RevisionName_s, Container=ContainerName_s, Message=Log_s | take 5" \
  --out table


az monitor log-analytics query \
  --workspace $LOG_ANALYTICS_WORKSPACE_CLIENT_ID \
  --analytics-query "ContainerAppConsoleLogs_CL | where ContainerAppName_s == 'storagequeuereader' and Log_s contains 'Message ID' and TimeGenerated > todatetime('2023-03-13 00:00:00') | summarize count()" \
  --out table