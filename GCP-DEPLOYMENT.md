# n8n GCP Cloud Run デプロイメントガイド

このガイドでは、n8nをGoogle Cloud Platform (GCP) のCloud Runにデプロイする方法を説明します。

## 前提条件

1. **Google Cloud アカウント**: GCPアカウントとプロジェクトが必要
2. **gcloud CLI**: ローカルマシンにGoogle Cloud CLIがインストールされている
3. **Docker**: ローカルでのテスト用（オプション）

## プロジェクト設定

使用するGCPプロジェクト:
- **プロジェクトID**: `2025-bitgrit-demos`
- **プロジェクト番号**: `1069282868629`
- **リージョン**: `asia-northeast1` (東京)

## デプロイ方法

### 方法1: 自動デプロイスクリプトを使用

最も簡単な方法です：

```bash
# リポジトリのルートディレクトリで実行
./deploy-gcp.sh
```

このスクリプトは以下を自動で行います：
- 必要なGCP APIの有効化
- 暗号化キーの生成
- Dockerイメージのビルドとデプロイ
- Cloud Runサービスの作成

### 方法2: 手動デプロイ

#### ステップ1: GCP認証とプロジェクト設定

```bash
# gcloud認証
gcloud auth login

# プロジェクト設定
gcloud config set project 2025-bitgrit-demos

# 必要なAPIを有効化
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

#### ステップ2: 暗号化キーの生成

```bash
# 暗号化キーを生成（重要：このキーを安全に保管してください）
N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)
echo "Generated encryption key: $N8N_ENCRYPTION_KEY"
```

#### ステップ3: Dockerイメージのビルドとプッシュ

```bash
# Dockerイメージをビルド
docker build -t gcr.io/2025-bitgrit-demos/n8n:latest -f Dockerfile.gcp .

# Container Registryにプッシュ
docker push gcr.io/2025-bitgrit-demos/n8n:latest
```

#### ステップ4: Cloud Runにデプロイ

```bash
gcloud run deploy n8n-service \
  --image gcr.io/2025-bitgrit-demos/n8n:latest \
  --region asia-northeast1 \
  --platform managed \
  --allow-unauthenticated \
  --port 8080 \
  --memory 2Gi \
  --cpu 2 \
  --max-instances 10 \
  --set-env-vars N8N_ENCRYPTION_KEY="$N8N_ENCRYPTION_KEY"
```

## 設定ファイルの説明

### Dockerfile.gcp
Cloud Run用に最適化されたDockerfile：
- Node.js 22 Alpine ベース
- pnpmを使用したビルド
- 環境変数でPORTを動的設定
- SQLiteデータベース使用

### cloudbuild.yaml
Cloud Build用の設定ファイル：
- Dockerイメージの自動ビルド
- Container Registryへのプッシュ
- Cloud Runへの自動デプロイ

### deploy-gcp.sh
ワンクリックデプロイスクリプト：
- 全工程を自動化
- エラーハンドリング
- 色付きの出力で進捗を表示

## 環境変数

主要な環境変数：

| 変数名 | 説明 | デフォルト値 |
|--------|------|-------------|
| `N8N_ENCRYPTION_KEY` | データ暗号化キー（必須） | なし |
| `N8N_HOST` | バインドホスト | `0.0.0.0` |
| `N8N_PORT` | リスニングポート | `8080` |
| `N8N_PROTOCOL` | プロトコル | `https` |
| `DB_TYPE` | データベースタイプ | `sqlite` |

## トラブルシューティング

### よくある問題

1. **ビルドエラー**
   ```bash
   # 依存関係をクリアして再ビルド
   pnpm clean
   pnpm install
   ```

2. **メモリ不足**
   ```bash
   # Cloud Runのメモリを増加
   gcloud run services update n8n-service \
     --memory 4Gi \
     --region asia-northeast1
   ```

3. **起動時間の超過**
   ```bash
   # CPUを増加
   gcloud run services update n8n-service \
     --cpu 4 \
     --region asia-northeast1
   ```

### ログの確認

```bash
# Cloud Runのログを確認
gcloud run services logs read n8n-service --region asia-northeast1
```

## セキュリティ考慮事項

1. **暗号化キー**: `N8N_ENCRYPTION_KEY`は安全に保管し、絶対に公開しないでください
2. **認証**: 本番環境では`--allow-unauthenticated`を削除し、適切な認証を設定してください
3. **データベース**: 本格運用時はCloud SQLなどの永続化データベースを検討してください

## 活用事例とユースケース

### 基本的な使い方
1. **Webhook受信**: 外部サービスからのデータを受信
2. **データ変換**: APIからのデータを別のフォーマットに変換
3. **通知送信**: Slack、Emailなどへの自動通知
4. **定期実行**: スケジュールされたタスクの実行

### ビジネス活用例
1. **顧客データ同期**: CRMと他システム間でのデータ同期
2. **レポート自動化**: 定期的なレポート生成と配信
3. **在庫管理**: ECサイトと在庫システムの連携
4. **ソーシャルメディア**: 投稿の自動化と分析

## 費用目安

Cloud Runの料金体系：
- **CPU**: $0.00001667/vCPU秒
- **メモリ**: $0.000001875/GB秒
- **リクエスト**: $0.0000004/リクエスト

月間1000回実行の場合、約$5-10程度の費用となります。

## 次のステップ

1. **データベース強化**: Cloud SQLへの移行
2. **認証強化**: Identity-Aware Proxyの設定
3. **監視設定**: Cloud Monitoringとアラートの設定
4. **バックアップ**: 定期バックアップの自動化

デプロイが完了したら、`https://your-service-url/` にアクセスしてn8nの初期設定を行ってください。