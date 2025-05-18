# IAM Authentication Audit Tracker

## 📘 Overview
In the world of cloud-native infrastructure, Identity and Access Management (IAM) is the first line of defense—and often the most targeted. Yet, too many organizations struggle to detect when IAM credentials are misused or abused. The **IAM Authentication Audit Tracker** simulates a real-world detection and response pipeline for IAM authentication behaviors using AWS-native services.

Built for security engineers, auditors, and GRC practitioners, this lab showcases how AWS CloudTrail, CloudWatch, and Lambda can work together to flag suspicious login patterns, enforce alerting policies, and feed audit trails into compliance reporting workflows. Whether you're preparing for a security assessment or defending a production environment, this tracker brings theory to life.

## 🎯 Objectives
- Monitor IAM authentication activities in real-time using AWS CloudTrail and CloudWatch.
- Detect anomalous or suspicious login behaviors (e.g., failed logins, logins from new IPs/regions).
- Trigger alerts through CloudWatch Alarms and AWS SNS.
- Automate audit log analysis using Athena and generate compliance-ready reports.
- Map detection logic and reports to NIST SP 800-53 (AU-6, AC-7) and ISO/IEC 27001 A.12.4.
- Demonstrate actionable cloud security GRC practices aligned with industry frameworks.

## 🗺️ Architecture Diagram
![IAM Architecture Diagram](./assets/iam-auth-arch.png)

## ⚙️ Prerequisites
(Insert Prerequisites section content here)

## 🧪 Lab Steps
(Insert Lab Steps content here)

## 🛠️ Automation (Terraform)
Terraform IaC is located in the `terraform/` folder.

## 📋 Compliance Mapping
(Insert Compliance Mapping section content here)

## 🧠 Skills Demonstrated
(Insert Skills Demonstrated section here)

## 📚 Resources
- AWS CloudTrail
- AWS CloudWatch
- Terraform
- Cloud Security Alliance (CCM)
- NIST 800-53, ISO/IEC 27001
