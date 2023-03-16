# keda-aca-queue-scalers-demo

Demo for Kubernetes Event Driven Architecture with Azure Containers Apps and Queues Scalers supported in Azure

## Overview

This repository contains a workflow that performs the following actions:

- Provision an [Azure Container Registry][acr]
- Build and deploy Service Bus Queue Producer and Reader container images using the previously deployed registry
- Provision an [Azure Container Apps Environment][aca] with 2 applications:
  - Storage Queue Reader, from public [Microsoft Artifact Registry][mcr]
  - Service Bus Queue Reader, from the previously deployed [Azure Container Registry][acr]
- Performs tests by putting messages in the corresponding queues:
  - Using the [Azure CLI][cli] for [Storage Queue][asq]
  - Using a Service Bus Queue Producer application hosted in an [Azure Container Instance][aci]
- Validates the expected number of messages have been processed via query to [Log Analytics Workspace][law]
- Destroy the resouce group where all resources were provisioned

[acr]: https://learn.microsoft.com/en-us/azure/container-registry/
[aca]: https://learn.microsoft.com/en-us/azure/container-apps/
[mcr]: https://mcr.microsoft.com/
[cli]: https://learn.microsoft.com/en-us/cli/azure/
[asq]: https://learn.microsoft.com/en-us/azure/storage/queues/
[aci]: https://learn.microsoft.com/en-us/azure/container-instances/
[law]: https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview