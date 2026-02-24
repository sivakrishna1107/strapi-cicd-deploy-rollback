# 🚀 Strapi Deployment on AWS ECS Fargate Spot using Terraform & GitHub Actions

## 📌 Project Overview

This project deploys a **Strapi CMS application** on AWS using:

- Amazon ECS (Fargate Spot)
- Amazon RDS (PostgreSQL)
- Application Load Balancer (ALB)
- Amazon ECR
- Terraform (Modular Infrastructure as Code)
- GitHub Actions (CI/CD)

The entire infrastructure and deployment process is fully automated - no manual Docker builds or Terraform apply steps.

---

## 🏗️ Architecture

GitHub → GitHub Actions (CI)
        → Build Docker Image
        → Push to ECR
        → Trigger CD
        → Terraform Apply
        → ECS Fargate Spot
        → ALB
        → Users

ECS tasks connect securely to RDS PostgreSQL.

---

## ☁️ AWS Services Used

- ECS Fargate Spot (Cost-optimized container compute)
- RDS PostgreSQL (Managed database)
- Application Load Balancer
- Elastic Container Registry (ECR)
- IAM
- Default VPC
- CloudWatch Logs (for container debugging)

---

## 🧱 Terraform Structure (Modular)

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── secrets.tf
└── modules/
    ├── security/
    ├── rds/
    ├── alb/
    └── ecs/
```

Each module has a single responsibility:

- security → Security groups
- rds → PostgreSQL database
- alb → Load balancer + target group
- ecs → Cluster, task definition, service

---

## 🔐 Secret Management

Strapi application secrets are generated dynamically using Terraform `random_password` resources.

This avoids hardcoding secrets in code or GitHub.

Secrets generated:
- APP_KEYS
- API_TOKEN_SALT
- ADMIN_JWT_SECRET
- JWT_SECRET

---

## 🐳 CI/CD Workflow

### CI Pipeline
- Triggered on push to `main`
- Builds Docker image
- Pushes image to ECR

### CD Pipeline
- Triggered after successful CI
- Runs `terraform apply`
- Deploys or updates ECS service
- Uses commit SHA as image tag

Fully automated deployment.

---

## 💰 Why Fargate Spot?

Fargate Spot was used to:
- Reduce compute cost (up to 70%)
- Run stateless container workloads
- Automatically handle task interruptions

Since Strapi stores state in RDS, it is safe to run on Spot capacity.

---

## 🌐 Accessing the Application

Open:

```
http://<alb_dns_name>
```
