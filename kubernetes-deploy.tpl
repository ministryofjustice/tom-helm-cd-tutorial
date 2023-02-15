apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloworld-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webserver
  template:
    metadata:
      labels:
        app: webserver
    spec:
      containers:
      - name: nginx
        image: ${ECR_URL}:${IMAGE_TAG}
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  labels:
    app: nginx-service
spec:
  ports:
  - port: 8080
    name: http
    targetPort: 8080
  selector:
    app: webserver
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
  namespace: tom-namespace-dev
  annotations:
    external-dns.alpha.kubernetes.io/set-identifier: ingress-tom-namespace-dev-green
    external-dns.alpha.kubernetes.io/aws-weight: "100"
spec:
  ingressClassName: default
  tls:
  - hosts:
    - tom-dstest.apps.live.cloud-platform.service.justice.gov.uk
  rules:
  - host: tom-dstest.apps.live.cloud-platform.service.justice.gov.uk
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: nginx-service
            port:
              number: 8080
