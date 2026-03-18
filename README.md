# AWS Study
　Terraform + Ansible + GitHub Actions

## 概要
aws学習のためTerraform、Ansible、GitHub Actionsを用いて、AWS上にWebアプリケーション環境を自動構築するものです。
インフラ構築からアプリデプロイまでをCI/CDで実行できる構成です。

## リソース

* VPC（Public / Private Subnet）
* ALB（Application Load Balancer）
* EC2（アプリ用）
* RDS（MySQL）
* WAF（ALB保護）
* IAM（SSM接続 + SSM用S3への限定アクセス）

---

## Terraformの構成

Terraformはリソース単位でファイル分割しています
* リソース単位で分割し可読性・保守性を確保
* IAMは最小権限の原則に基づいて設定

### ネットワーク関係

* vpc.tf
* public_subnet.tf / private_subnet.tf
* route_table_public.tf / route_table_private.tf

### セキュリティ関係

* security_group_ec2.tf
* security_group_alb.tf
* security_group_rds.tf

### コンピュート関係

* ec2.tf
* iam.tf

### データベース関係

* rds.tf
* rds_subnet_group.tf

### ロードバランサー関係

* alb.tf
* alb_listener.tf
* alb_target_group.tf

### WAF関係

* waf.tf
* waf_association.tf
* waf_logging.tf

### 共通

* providers.tf
* variables.tf
* locals.tf
* outputs.tf
* backend.tf

---

## CI/CD（GitHub Actions）

### push（task43ブランチ）

　PRのためにブランチにpushで動作
* Terraform apply
* Ansibleによるアプリデプロイ

---

## AWS認証

GitHub ActionsからAWSへのアクセスはOIDCを利用
* アクセスキー不要で安全性を考慮

---

## Ansible

* SSM接続でEC2にログイン不要
* Javaインストール
* template + systemdで実装
* アプリのビルドとデプロイを実施

---



