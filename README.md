# Blue-Green Deployment with Kubernetes and Terraform

## Manual Blue-Green Deployment

### Overview
Blue-Green deployment is a strategy to minimize downtime and reduce risk during application updates. It involves maintaining two environments (Blue & Green) and switching traffic between them.

### Steps for Manual Deployment
1. **Deploy the Blue Environment**
   - Deploy the application (blue version) using Kubernetes.
   - Expose the blue deployment via a service.
   - Verify application functionality.

2. **Deploy the Green Environment**
   - Deploy the new version of the application (green version) alongside the blue version.
   - Expose the green deployment via a separate service.
   - Perform application testing on the green version.

3. **Switch Traffic to Green**
   - Update the Ingress configuration or service selector to route traffic to the green deployment.
   - Monitor application performance.
   - If everything works fine, remove the blue deployment.

## Automating Blue-Green Deployment with Terraform

### Overview
Terraform automates the creation and management of Kubernetes resources, reducing manual effort and ensuring repeatability.

### Prerequisites
- Terraform installed
- kubectl configured to access the cluster
- Kubernetes cluster running (e.g., Minikube)

### Steps to Deploy Using Terraform
1. **Initialize Terraform**
   ```sh
   terraform init
   ```
2. **Plan the Deployment**
   ```sh
   terraform plan
   ```
3. **Apply the Configuration**
   ```sh
   terraform apply -auto-approve
   ```
4. **Verify Deployment**
   ```sh
   kubectl get pods
   kubectl get services
   kubectl get ingress
   ```

### Key Terraform Resources
- `kubernetes_deployment`: Defines application deployments.
- `kubernetes_service`: Exposes the deployments.
- `kubernetes_ingress_v1`: Manages traffic routing.

## Screenshots and Documentation
- Terminal outputs and deployment logs are available in the `screenshots.pdf` file.


## Cleanup
To remove all resources:
```sh
terraform destroy -auto-approve
```

## Conclusion
This project demonstrates both a manual and automated approach to Blue-Green deployment in Kubernetes. Terraform ensures efficiency and repeatability, reducing the need for manual interventions.

