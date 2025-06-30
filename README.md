# IAM Authentication Audit Tracker 🛡️

![GitHub Release](https://img.shields.io/badge/Release-v1.0.0-blue?style=flat-square&logo=github)

Welcome to the IAM Authentication Audit Tracker repository! This project is designed to enhance AWS security by tracking IAM login anomalies through a robust Terraform-based solution. Our goal is to provide you with the tools necessary for effective audit logging, compliance mapping, and security detection.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Compliance](#compliance)
- [Contributing](#contributing)
- [License](#license)
- [Releases](#releases)
- [Contact](#contact)

## Introduction

The IAM Authentication Audit Tracker leverages AWS services such as CloudTrail, CloudWatch, SNS, and Athena to monitor and analyze IAM authentication activities. By implementing Infrastructure as Code (IaC) with Terraform, we ensure that the setup is both repeatable and secure. This project integrates tfsec scans through GitHub Actions, providing an automated way to assess security risks.

## Features

- **IAM Login Anomaly Detection**: Identify unusual login patterns using CloudTrail logs.
- **Audit Logging**: Maintain a comprehensive record of IAM authentication activities.
- **Compliance Mapping**: Align with NIST 800-53 (AU-6, AC-7) and ISO 27001 A.12.4 standards.
- **Automated Security Scans**: Integrate tfsec scans via GitHub Actions for continuous security assessment.
- **Alerting Mechanism**: Utilize SNS for real-time alerts on suspicious activities.
- **Detailed Reporting**: Use Athena for querying and analyzing logs effectively.

## Architecture

The architecture of the IAM Authentication Audit Tracker consists of several AWS services working together:

1. **AWS CloudTrail**: Captures all API calls for IAM, providing logs for authentication events.
2. **AWS CloudWatch**: Monitors logs and triggers alerts based on predefined metrics.
3. **AWS SNS**: Sends notifications for any detected anomalies.
4. **AWS Athena**: Allows querying of CloudTrail logs for detailed analysis.
5. **Terraform**: Manages the infrastructure setup as code.

![Architecture Diagram](https://via.placeholder.com/800x400.png?text=Architecture+Diagram)

## Getting Started

To get started with the IAM Authentication Audit Tracker, follow these steps:

### Prerequisites

- An AWS account
- Terraform installed on your local machine
- AWS CLI configured with necessary permissions

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/fnatio213/iam-authentication-audit-tracker.git
   cd iam-authentication-audit-tracker
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review and modify the `variables.tf` file to suit your environment.

4. Apply the Terraform configuration:

   ```bash
   terraform apply
   ```

### Configuration

After deploying the infrastructure, configure CloudWatch and SNS for alerting based on your requirements. You can modify the alert thresholds in the `cloudwatch.tf` file.

## Usage

Once the setup is complete, the IAM Authentication Audit Tracker will begin monitoring IAM login activities. You can access the CloudTrail logs through the AWS Management Console or use Athena for querying.

### Querying Logs with Athena

To analyze the logs, navigate to the Athena console and run queries against the CloudTrail logs stored in S3. Here’s a sample query to find failed login attempts:

```sql
SELECT eventTime, userIdentity.userName, eventName
FROM cloudtrail_logs
WHERE eventName = 'ConsoleLogin' AND errorCode = 'FailedAuthentication'
ORDER BY eventTime DESC
```

### Alerts

Configure SNS to receive notifications for any detected anomalies. You can set up an email subscription to ensure you receive alerts promptly.

## Compliance

The IAM Authentication Audit Tracker supports compliance with the following standards:

- **NIST 800-53**: Focus on AU-6 (Audit Review, Analysis, and Reporting) and AC-7 (Unsuccessful Login Attempts).
- **ISO 27001**: Align with A.12.4 (Logging and Monitoring).

Regular audits and log reviews will help maintain compliance and improve security posture.

## Contributing

We welcome contributions from the community. If you have suggestions or improvements, please fork the repository and submit a pull request. 

### Steps to Contribute

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push your branch and create a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Releases

You can find the latest releases [here](https://github.com/fnatio213/iam-authentication-audit-tracker/releases). Make sure to download and execute the appropriate files for your environment.

## Contact

For questions or support, please open an issue in the repository or contact the maintainers directly.

---

Thank you for checking out the IAM Authentication Audit Tracker! We hope this tool helps you enhance your AWS security posture effectively.