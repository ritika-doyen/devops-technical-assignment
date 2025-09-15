# DevOps Technical Assignment

This repository contains solutions to the given technical assignment.  
Each question is placed in its own folder (`Q1` … `Q5`) with code, configuration, and documentation.

---

## Folder Structure

devops-technical-assignment/
│
├── Q1/ # Terraform multi-tier VPC + ALB
│ ├── versions.tf
│ ├── provider.tf
│ ├── variables.tf
│ ├── data.tf
│ ├── vpc.tf
│ ├── security.tf
│ ├── ec2.tf
│ ├── alb.tf
│ ├── outputs.tf
│ ├── terraform.tfvars.example
│ └── README.md
│
├── Q2/ # Circuit Breaker in Python
│ ├── circuit_breaker.py
│ ├── diagram.png
│ └── README.md
│
├── Q3/ # Troubleshooting + Monitoring
│ ├── analysis.md
│ ├── monitoring-architecture.png
│ └── incident-response-flowchart.png
│
├── Q4/ # DevOps judgment response
│ └── README.md
│
├── Q5/ # Kubernetes + Istio multi-service app
│ ├── manifests/
│ │ ├── frontend-deployment.yaml
│ │ ├── frontend-service.yaml
│ │ ├── backend-deployment.yaml
│ │ ├── backend-service.yaml
│ │ ├── database-deployment.yaml
│ │ └── database-service.yaml
│ ├── istio/
│ │ ├── gateway.yaml
│ │ ├── virtualservice.yaml
│ │ ├── destinationrule.yaml
│ │ └── policy.yaml
│ └── README.md
│
└── README.md # This file

---

## Time Spent on Each Question

- **Q1 (Terraform VPC + ALB)**: ~4 hours  
- **Q2 (Circuit Breaker Pattern)**: ~2 hours  
- **Q3 (Troubleshooting & Monitoring)**: ~5 hours  
- **Q4 (DevOps judgment response)**: ~1.5 hours  
- **Q5 (Kubernetes + Istio)**: ~7 hours  

---

## Reflection on the Assignment

This assignment covered a wide range of real-world DevOps concepts:  

- **Infrastructure as Code (Q1):** Reinforced best practices for modular Terraform, state management, least-privilege security groups, and using variables/tags for scalability.  
- **Resilience Patterns (Q2):** Circuit Breaker implementation highlighted how to protect microservices from cascading failures and integrate resilience into DevOps pipelines.  
- **Troubleshooting & Monitoring (Q3):** Emphasized structured problem-solving, combining root cause analysis with monitoring architecture design and incident response planning.  
- **Professional Judgment (Q4):** Showcased the importance of communication, risk management, and ethical responsibility when pressured to bypass DevOps safeguards.  
- **Kubernetes + Istio (Q5):** Strengthened understanding of service mesh concepts like traffic routing, observability, and security policies, and how they complement Kubernetes deployments.  

---

## Areas for Further Learning

- Deep dive into **Terraform modules** and **state backends** (S3 + DynamoDB for collaboration).  
- Advanced **Istio traffic management** (canary, blue-green, A/B testing).  
- Chaos engineering to test circuit breaker, scaling, and monitoring solutions.  
- Building automated **incident response playbooks** using AWS Systems Manager or PagerDuty.  
- Improving **observability pipelines** with OpenTelemetry + Grafana Tempo/Prometheus.  

---

## How to Use

1. Clone the repository.  
2. Each `Qx/` folder has its own `README.md` with instructions.  
3. Follow setup steps (Terraform for Q1, Python for Q2, Kubernetes + Istio for Q5).  
4. Diagrams are included in Q2, Q3, and Q5 for architecture visualization.  

---

**Author:** Ritika Shah  
**Repo:** `devops-technical-assignment`  
