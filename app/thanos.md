Thanos service that uses the Bitnami package for Thanos. Thanos is a highly available metrics system that can be added on top of existing Prometheus deployments, providing a global query view across all Prometheus installations.

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

This service will create the Thanos services as follows:

- It will create a Thanos frontend.
- It will create a Thanos receiver.
- It will create a read-write service that will be used by the Thanos service.

This app uses Minikube and Helm charts.

To install the chart with the release name `thanos-release`:
