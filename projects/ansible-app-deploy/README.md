# Terraform × GitHub Actions × Ansible によるAWS自動CI/CDパイプライン構築   

## 概要
GitHub Actionsを用いて、TerraformによるAWSインフラ構築から、
Ansibleによるアプリデプロイまでを一貫したCI/CDパイプラインを構築しました。

CIではコードの検証と差分検出を実施し、
CDではdev環境での事前検証後、承認フローを経てprod環境へデプロイされる構成としています。

---

# 背景

本構成はスクールの学習課題をベースとしていますが、
以下の点を意識して改善・理解を深めました。

* CI/CDの役割分離（CI：検証、CD：デプロイ）
* dev → prodの段階的デプロイ構成
* TerraformとAnsibleの役割分担の明確化
* 手動作業を排除した自動化の実現

---

## 環境構成

### ■ ネットワーク
* VPC（10.0.0.0/16）
* Public Subnet ×2（10.0.1.0/24、10.0.2.0/24）
* Private Subnet ×2（10.0.3.0/24、10.0.4.0/24）
* Internet Gateway
* Route Table（Public）

---

### ■ サーバー構成

* ALB（Application Load Balancer）
* EC2（t3.micro）×1
* RDS（db.t3.micro）×1

---

### ■ セキュリティ
* Security Group設計
  * ALB HTTP(80), HTTPS(443)
  * EC2 HTTP(8080)
  * RDS MySQL(3306)
* WAF（AWS Managed Rules）
  * AWSManagedRulesCommonRuleSetを適用

---

### ■ 運用監視・ログ

* WAFログ
  - CloudWatch Logsへ出力し、リクエスト内容を確認可能

---

## 使用技術
* Terraform（IaC）
* GitHub Actions（CI/CD）
* Ansible（アプリデプロイ自動化）
* AWS（VPC / EC2 / RDS / ALB / WAF / CloudWatch）
* SSM（EC2接続）
* S3（backend）
* DynamoDB（ロック管理）

---

## ディレクトリ構成

```bash
aws-study/
├── .github/
│   └── workflows/
│       └── ansible-app-deploy.yml     # Terraform + AnsibleによるCI/CD
│ 
├── projects/
│   └── ansible-app-deploy/
│       ├── tf/                        # Terraformリソース定義
│       │   ├── *.tf                   # 各種リソース（VPC / EC2 / ALB / RDSなど）
│       │   └── tests/                 # Terraform test用のテスト定義
│       │
│       └── docs/                      # 実行結果（plan / apply証跡）
│
└── README.md
```

--- 

## テスト内容
* VPCのCIDRブロックが正しいか
* パブリックサブネットのCIDRブロック確認
* プライベートサブネットのCIDRブロック確認
* ALB、EC2、RDSのポート設定確認
* EC2、RDSのインスタンスタイプ確認

--- 

## CI（継続的インテグレーション）

GitHub Actionsにより、PR作成時にdev環境で自動実行 

```bash
CI（検証）
  ├ terraform fmt
  ├ terraform validate
  ├ terraform test
  └ terraform plan
```

---

## CD（継続的デプロイ）
* 事前確認（dev環境）
workflow_dispatchを用いて手動実行

```bash
CD（dev環境）
  ├ terraform apply（インフラ構築）
  └ ansible-playbook（アプリデプロイ）
```

* 本番デプロイ（prod環境）
mainブランチへマージ時に承認確認
承認後に自動実行

```bash
CD（prod環境）
  ├ terraform fmt
  ├ terraform validate
  ├ terraform test
  ├ terraform plan
  ├ terraform apply（インフラ構築）
  └ ansible-playbook（アプリデプロイ）
```

---

## 動作確認

* CI確認
  - planが正常実行されることを確認

 
![plan結果](docs/plan1_result-1.png)


* CD確認
  - dev環境で手動applyし、構成通りにリソースが作成されることを確認

 手動apply結果
 
![dev結果1](docs/dev1_result-1.png)

![dev結果2](docs/dev1_result-2.png)

![dev1結果3](docs/dev1_ec2.png)

  - mainマージして承認後にprod環境に自動デプロイされることを確認

![prod結果1](docs/prod_result-1.png)

![prod結果2](docs/prod_result-2.png)

---

## 工夫した点・学んだこと
* CI/CDの分離
  * CI：検証（planまで）
  * CD：環境、アプリデプロイ（apply）
  
* 事前デプロイ確認
  * workflow_dispatchを利用し、mainマージ前に動作確認

