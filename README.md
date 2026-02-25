# 🚀 Strapi Blue/Green Deployment on AWS ECS (Fargate)

This project demonstrates a complete Blue/Green deployment architecture for a Strapi application using:

- Amazon ECS (Fargate)
- AWS CodeDeploy (Blue/Green strategy)
- Application Load Balancer (ALB)
- Amazon RDS (PostgreSQL)
- Amazon ECR
- Terraform (Modular Infrastructure)
- GitHub Actions (CI/CD)

---

## 🏗 Architecture Overview

- Strapi runs in ECS Fargate
- Application Load Balancer routes traffic
- Two target groups (Blue & Green)
- CodeDeploy manages traffic shifting
- RDS PostgreSQL as database
- ECR stores Docker images
- Terraform provisions infrastructure
- GitHub Actions handles CI/CD

---

## 🔄 Deployment Strategy

Blue/Green deployment using: 
CodeDeployDefault.ECSCanary10Percent5Minutes

Flow:
1. New task set (Green) is created
2. 10% traffic shifted
3. Wait 5 minutes
4. 100% traffic shifted
5. Old task set terminated

Zero downtime deployment ✅

---

## ⚙️ Infrastructure (Terraform Modules)

- VPC (Default VPC used)
- ECS Cluster & Service
- ALB & Target Groups
- CodeDeploy Application & Deployment Group
- RDS PostgreSQL
- CloudWatch Log Group
- Security Groups

---

SSL is required for secure RDS connectivity.

---

## 🚀 CI/CD Flow

### 1️⃣ Infrastructure Workflow (`infra.yml`)
- Runs Terraform init/plan/apply
- Provisions full AWS infrastructure

### 2️⃣ CI Workflow (`ci.yml`)
- Builds Docker image
- Pushes image to Amazon ECR

### 3️⃣ CD Workflow (`cd.yml`)
- Fetches existing task definition
- Updates container image
- Registers new revision
- Triggers CodeDeploy deployment

---

## 🧪 How to Deploy

### Step 1 – Deploy Infrastructure
Push changes to `terraform/` folder.

### Step 2 – Build & Push Image
Push changes to `strapi-app/`.

### Step 3 – Automatic Blue/Green Deployment
CodeDeploy handles traffic shifting.

---

## ✅ Verification Checklist

- CodeDeploy deployment status = Succeeded
- ECS tasks = Running & Healthy
- Target groups = Healthy
- ALB DNS loads Strapi
- No downtime during deployment


