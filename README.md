# keda-aca-queue-scalers-demo

Demo for Kubernetes Event Driven Architecture with Azure Containers Apps and Queues Scalers supported in Azure

## Overview

This repository contains a workflow that performs the following actions:

- Provision an Azure Container Registry
- Build and deploy Service Bus Queue Producer and Reader container images using the previously deployed registry
- Provision an Azure Container Apps Environment with 2 applications:
  - Storage Queue Reader
  - Service Bus Queue Reader
- Performs tests by producing test messages in the corresponding queues:
  - Using the Azure CLI for Storage Queue
  - Using a Service Bus Queue Producer application hosted in an Azure Container Instance
- Validates the expected number of messages have been processed
- Destroy the resouce group where all resources were provisioned
