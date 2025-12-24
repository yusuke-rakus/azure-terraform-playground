# **Terraform 運用手順（Plan / Apply / Destroy）**

本リポジトリでは、環境ごとに tfvars を分離し、**Plan → Apply → Destroy** を明示的に実行する運用を採用しています。

---

## **前提条件**

- Terraform がインストール済みであること
- 対象環境ごとに tfvars が用意されていること

```
.
├── main.tf
├── variables.tf
├── outputs.tf
└── env/
    ├── dev.tfvars
    ├── stg.tfvars
    └── prod.tfvars
```

---

## **初期化（初回 or provider / backend 変更時）**

```
terraform init
```

- Provider / Backend / Module を初期化します
- 設定変更があった場合は再実行してください

---

## **Plan（差分確認）**

### **環境を指定して plan を実行**

```
terraform plan -var-file="env/dev.tfvars"
```

- 実際の変更は行われません
- どのリソースが **作成 / 更新 / 削除** されるかを確認します

---

## **推奨：Plan 結果を固定する（安全）**

```
terraform plan -var-file="env/dev.tfvars" -state=".tfstate/dev.tfstate" -out=".tfstate/dev.tfplan"
```

- この時点の差分をファイルとして保存します
- Apply 時の再計算を防ぐため、**実務では必須**です

---

## **Apply（リソース反映）**

### **Plan ファイルを指定して apply（推奨）**

```
terraform apply -state=".tfstate/dev.tfstate" ".tfstate/dev.tfplan"
```

- Plan 時の内容そのままで適用されます
- 意図しない差分の混入を防止できます

---

## **Destroy（環境削除）**

### **削除前に destroy plan を作成（必須）**

```
terraform plan -destroy -var-file="env/dev.tfvars" -state=".tfstate/dev.tfstate" -out=".tfstate/dev.destroy.tfplan"
```

- 削除対象のリソースを事前に確認できます
- 指定した環境（例：dev）のみが対象になります

---

### **destroy plan を適用して削除**

```
terraform apply -state=".tfstate/dev.tfstate" ".tfstate/dev.destroy.tfplan"
```

- Plan 時の内容そのままで削除されます
- 直接 `terraform destroy` は使用しません

---

## **注意事項（重要）**

- env/\*.tfvars は **自動では読み込まれません**
- plan と apply では **必ず同じ tfvars を指定**してください
- Azure Portal からの手動削除は行わないでください（state 不整合の原因）

---

## **よく使うコマンドまとめ**

```
# 初期化
terraform init

# plan
terraform plan -var-file="env/dev.tfvars" -state=".tfstate/dev.tfstate" -out=".tfstate/dev.tfplan"

# apply
terraform apply -state=".tfstate/dev.tfstate" ".tfstate/dev.tfplan"

# destroy
terraform plan -destroy -var-file="env/dev.tfvars" -state=".tfstate/dev.tfstate" -out=".tfstate/dev.destroy.tfplan"
terraform apply -state=".tfstate/dev.tfstate" ".tfstate/dev.destroy.tfplan"
```
