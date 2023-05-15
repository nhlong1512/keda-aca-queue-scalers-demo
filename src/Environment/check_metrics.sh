#!/bin/bash

resource_group=$1
acaname=$2"acae"
appname=$3
start_date=$4
maxmessages=$5
sleeptime=0.25s
maxtimes=10
l=1
messages=0

lawid=`az containerapp env show --name $acaname --resource-group $resource_group --query properties.appLogsConfiguration.logAnalyticsConfiguration.customerId --out tsv`
echo "Checking metrics for $acaname, expecting to process $maxmessages messages by $appname"

while [ $l -lt $maxtimes ];
do
  echo -n "."

  result=`az monitor log-analytics query \
    --workspace $lawid \
    --analytics-query "ContainerAppConsoleLogs_CL | where ContainerAppName_s == '$appname' and Log_s contains 'Message ID' and TimeGenerated > todatetime('$start_date') | summarize count()" \
    --out tsv`
  messages=${result:14:5}
  if [ "$messages" -ge $maxmessages ]; then
    break
  fi

  sleep $sleeptime
  ((l++))
done

if [ "$messages" -ge "$maxmessages" ]; then
  echo "Messages processed: $messages, Success!!!"
else
  echo "Messages processed: $messages, Failed!!!"
  exit 1
fi

echo ""
echo "done"
