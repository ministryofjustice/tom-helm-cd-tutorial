# Default values for multi-container-app.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

databaseUrlSecretName: rds-postgresql-instance-output
contentapiurl: "http://content-api-service:4567/image_url.json"
                
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: "true"
    external-dns.alpha.kubernetes.io/set-identifier: multi-container-app-tom-namespace-dev-green
    external-dns.alpha.kubernetes.io/aws-weight: "100"
  hosts:
    - host: tom-helm-cd.apps.live.cloud-platform.service.justice.gov.uk
      paths: []
  # Update tls for custom domain and update secretName where certificate is stored
  # tls:
  #   - secretName: <CERTIFICATE-SECRET-NAME>
  #     hosts:
  #       - <DNS-PREFIX>.apps.live.cloud-platform.service.justice.gov.uk
    
postgresql:
  enabled: true
  existingSecret: container-postgres-secrets
  postgresqlDatabase: multi_container_demo_app
  persistence:
    enabled: false

contentapi:
  replicaCount: 1
  image:
    repository: ${ECR_URL}
    tag: content-api-${GITHUB_SHA}
    pullPolicy: IfNotPresent
  containerPort: 4567
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""
  service:
    type: ClusterIP
    port: 4567
    targetPort: 4567

railsapp:
  replicaCount: 1
  image:
    repository: ${ECR_URL}
    tag: rails-app-${GITHUB_SHA}
    pullPolicy: IfNotPresent
  containerPort: 3000
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""
  service:
    type: ClusterIP
    port: 3000
    targetPort: 3000
  job:
    backoffLimit: 4
    restartPolicy: OnFailure

worker:
  replicaCount: 1
  image:
    repository: ${ECR_URL}
    tag: worker-${GITHUB_SHA}
    pullPolicy: IfNotPresent
  containerPort: 4567
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""
