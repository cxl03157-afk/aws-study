# AWSによるインフラ環境構築・CI/CD構成

## 概要
AWSを用いたインフラ構築およびCI/CDパイプラインを構築しました。  
TerraformによるIaC、GitHub Actionsによる自動化、Ansibleによるアプリデプロイまで一連の流れを実装しています。

詳細は各フォルダのREADMEを参照してください。

---

## ディレクトリ構成
```bash
learning
  ├ cloudformation-webapp-monitoring  CloudFormationによる環境構築
  ├ terraform-webapp-monitoring       Terraformによる環境構築
  └ tf-webapp-monitoring-tests        Terraform testによる自動テスト

projects
  ├ terraform-aws-deploy              Terraform + GitHub ActionsによるインフラCI/CD
  └ ansible-app-deploy                Terraform + AnsibleによるアプリデプロイCI/CD

```
---

# 特徴
* Terraformによるインフラのコード管理（IaC）
* GitHub ActionsによるCI/CD自動化
* Ansibleによるアプリケーションデプロイ
* dev/prod環境の分離
* 本番環境へのデプロイ時に承認フローを導入
