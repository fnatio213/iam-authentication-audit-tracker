# IAM Authentication Audit Tracker
![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?logo=terraform&logoColor=white)
![AWS Region](https://img.shields.io/badge/Region-us--east--1-orange?logo=aws)
![Compliance](https://img.shields.io/badge/NIST_SP800--53-AU--6,_AC--7-blue)
![ISO 27001](https://img.shields.io/badge/ISO_27001-A.12.4-success)
![Audit Ready](https://img.shields.io/badge/Audit-Trail_Enabled-brightgreen)
![Skill Focus](https://img.shields.io/badge/Skills-SecOps_&_GRC-blueviolet)
![tfsec status](https://img.shields.io/badge/tfsec-Demo_Lab_Insecure-red)

> ⚠️ **Security Lab Mode**: The initial version of this Terraform config was intentionally insecure to demonstrate common findings from tfsec and educate on remediations. See GitHub Actions logs for full vulnerability breakdown.
![Security Hardened](https://img.shields.io/badge/Status-Hardened_GRC_Compliant-brightgreen)

> ✅ **Hardened Mode Enabled**: The current Terraform code has been updated to include encryption, access restrictions, and compliance enhancements following NIST 800-53, CIS Benchmarks, and tfsec recommendations.

## 🔁 Before vs After: Security Hardening Comparison

| Component         | Insecure Demo Version                                          | Hardened GRC Version                                              |
|------------------|----------------------------------------------------------------|-------------------------------------------------------------------|
| **S3 Bucket**     | No encryption, no logging, no public access blocking          | Encrypted with KMS, versioning enabled, logging, public access blocked |
| **CloudTrail**    | No log validation, no encryption                              | KMS encryption enabled, log file validation turned on            |
| **CloudWatch Logs** | Unencrypted log group                                        | KMS-encrypted log group with 90-day retention                    |
| **IAM Policy**    | Wildcard `*` resource permission                              | Scoped to specific CloudWatch log group ARN                      |
| **SNS Topic**     | No encryption                                                 | Encrypted with KMS                                               |
| **Security Tooling** | tfsec detects 15 high/med/low issues                       | tfsec passes — all high severity issues remediated               |

> 📘 This comparison illustrates how the Terraform code was transformed from a security demo mode into a compliant, hardened infrastructure-as-code pipeline.

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

### 🔐 AWS Account
- An active AWS account with **AdministratorAccess** or equivalent IAM permissions:
  - IAM, CloudTrail, CloudWatch, SNS, Lambda, Athena, and S3

### 🛠️ Tools & Setup
- AWS CLI v2 (`aws configure`)
- Terraform
- IAM user with programmatic access
- Optional: VS Code + AWS Toolkit

### 📦 AWS Services Enabled
- **CloudTrail** with S3 + CloudWatch Logs
- **Athena** + **S3** for queries
- **CloudWatch Alarms**, **SNS**, **Lambda**

### 📝 IAM Permissions Required
- `CloudTrailFullAccess`
- `CloudWatchFullAccess`
- `AmazonS3FullAccess`
- `AmazonAthenaFullAccess`
- `AWSLambda_FullAccess`
- `AmazonSNSFullAccess`
- `AWSConfigUserAccess`

## 🧪 Lab Steps

1. **Enable CloudTrail** with S3 + CloudWatch Logs delivery.
2. **Create Log Metric Filter** in CloudWatch for failed `ConsoleLogin`.
3. **Set CloudWatch Alarm** to detect 5+ failed logins in 5 minutes.
4. **Create SNS Topic** for security alerts.
5. *(Optional)* Add Lambda for alert enrichment.
6. **Use Athena** to query logs and detect trends.

## 🛠️ Automation (Terraform)
Terraform IaC is located in the `terraform/` folder and includes:
- S3 bucket for CloudTrail logs
- CloudTrail with CloudWatch Logs integration
- IAM role/policy for CloudTrail logging
- Metric filter and alarm for failed logins
- SNS for alerting
> ⚠️ **Security Scan Findings (tfsec):**
> 
> This Terraform configuration is intentionally left with known misconfigurations for demo purposes.  
> The GitHub Actions pipeline runs `tfsec`, which reports issues like:
> - Missing S3 encryption
> - Lack of CloudTrail log validation
> - Wildcard IAM permissions
> - Unencrypted SNS topics and log groups
> 
> These findings help illustrate how IaC scans detect misconfigured resources before deployment.

## 📋 Compliance Mapping

| Framework | Control       | Mapping Details |
|-----------|---------------|------------------|
| NIST 800-53 | AU-6, AC-7   | Alerting on login failures, centralized logging |
| ISO 27001   | A.12.4       | Monitoring and audit logs |
| CSA CCM     | IAM-03, SEF-02 | IAM behavior tracking and audit enablement |
| CIS v8      | Controls 5, 8 | Account + audit log management |

## 🧠 Skills Demonstrated

- AWS CloudTrail + CloudWatch integration
- Terraform IaC for security detection setup
- Audit log querying with Athena
- Compliance mapping (NIST, ISO, CSA)
- Detection of IAM anomalies and alerting

## 📚 Resources
- AWS CloudTrail
- AWS CloudWatch
- Terraform
- Cloud Security Alliance (CCM)
- NIST 800-53, ISO/IEC 27001
