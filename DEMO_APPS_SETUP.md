# デモアプリケーション セットアップガイド

## 概要

このドキュメントでは、以下のOSSツールのデプロイとデモ環境構築について説明します：

1. n8n - ワークフロー自動化プラットフォーム
2. dify - LLMアプリケーション開発プラットフォーム
3. Deep Research系ツール
4. OpenAIカスタマーサポートデモ

## 1. n8n (ワークフロー自動化)

### 概要
n8nは400以上の統合機能を持つワークフロー自動化プラットフォームです。コードとノーコードの柔軟性を組み合わせ、AI機能もネイティブサポートしています。

### ローカル環境での起動

#### 方法1: npx (推奨)
```bash
npx n8n
```
- ポート: http://localhost:5678
- 初回セットアップで管理者アカウント作成

#### 方法2: Docker
```bash
docker volume create n8n_data
docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
```

### Railway デプロイ
```bash
# railway CLI インストール
npm install -g @railway/cli

# ログイン
railway login

# プロジェクト作成
railway new

# デプロイ
railway up
```

### GCP CloudRun デプロイ
```yaml
# cloudbuild.yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/2025-bitgrit-demos/n8n', '.']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'gcr.io/2025-bitgrit-demos/n8n']
  - name: 'gcr.io/cloud-builders/gcloud'
    args: ['run', 'deploy', 'n8n', '--image', 'gcr.io/2025-bitgrit-demos/n8n', '--platform', 'managed', '--region', 'asia-northeast1']
```

### 基本的な活用事例
1. **API統合ワークフロー**: Slack通知 + Google Sheets更新
2. **データ処理パイプライン**: CSV処理 + データベース更新
3. **AIワークフロー**: LangChain統合でテキスト処理
4. **Webhook自動化**: フォーム送信 → メール送信 → CRM更新

## 2. dify (LLMアプリケーション開発)

### 概要
difyはLLMアプリケーションの開発・デプロイを簡素化するオープンソースプラットフォームです。

### Docker Compose セットアップ
```bash
git clone https://github.com/langgenius/dify.git
cd dify/docker
cp .env.example .env
docker-compose up -d
```

### Railway デプロイ
```dockerfile
# Dockerfile
FROM langgenius/dify-web:0.6.10
EXPOSE 3000
```

### 基本的な活用事例
1. **チャットボット構築**: カスタマーサポート対応
2. **RAG (Retrieval-Augmented Generation)**: 社内文書検索
3. **コンテンツ生成**: ブログ記事・メール生成
4. **データ分析アシスタント**: CSV分析 + グラフ生成

## 3. Deep Research系ツール

### 候補ツール
1. **storm-gpt**: [GitHub](https://github.com/stanford-oval/storm)
   - スタンフォード大学開発の研究自動化ツール
   - 論文調査 + レポート生成

2. **research-assistant**: [GitHub](https://github.com/assafelovic/gpt-researcher)
   - GPT研究者エージェント
   - ウェブ検索 + 情報統合

3. **perplexica**: [GitHub](https://github.com/ItzCrazyKns/Perplexica)
   - オープンソースのPerplexity AI代替

### デプロイ構成例 (storm-gpt)
```yaml
# docker-compose.yml
version: '3.8'
services:
  storm:
    build: .
    ports:
      - "8000:8000"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - SEARCH_ENGINE_ID=${SEARCH_ENGINE_ID}
```

### 活用事例
1. **市場調査**: 競合分析 + トレンド分析
2. **技術調査**: 新技術の評価 + 導入提案
3. **学術研究**: 論文調査 + サマリー作成
4. **投資判断**: 企業分析 + リスク評価

## 4. OpenAI カスタマーサポートデモ

### リポジトリ
https://github.com/openai/openai-cs-agents-demo

### セットアップ手順
```bash
git clone https://github.com/openai/openai-cs-agents-demo.git
cd openai-cs-agents-demo

# 環境変数設定
cp .env.example .env
# OPENAI_API_KEY を設定

# フロントエンド (React)
cd frontend
npm install
npm start

# バックエンド (Python)
cd ../backend
pip install -r requirements.txt
python main.py
```

### Railway デプロイ構成
```
# フロントエンド用 railway.toml
[build]
  builder = "NIXPACKS"
  buildCommand = "npm run build"

[deploy]
  startCommand = "npm start"
  restartPolicyType = "ON_FAILURE"

# バックエンド用 railway.toml
[build]
  builder = "NIXPACKS"

[deploy]
  startCommand = "python main.py"
```

### 機能概要
1. **チケット管理**: 顧客問い合わせの自動分類
2. **自動応答**: FAQ + 過去事例ベースの回答生成
3. **エスカレーション**: 複雑な問題の人間オペレーター転送
4. **分析ダッシュボード**: 対応品質 + 効率性の可視化

## デプロイメント戦略

### Railway (推奨)
- **メリット**: シンプルなデプロイ、GitHub連携
- **制限**: リソース制限、有料プラン必要
- **適用**: プロトタイプ、小規模デモ

### GCP CloudRun
- **メリット**: スケーラブル、従量課金
- **制限**: 単一ポート、状態保持なし
- **適用**: ステートレスなAPI、Webアプリ

### GCP Cloud Functions
- **メリット**: イベント駆動、自動スケール
- **制限**: 実行時間制限、コールドスタート
- **適用**: バッチ処理、Webhook処理

## 環境変数管理

### 共通環境変数
```bash
# AI API Keys
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...

# Database
DATABASE_URL=postgresql://...
SUPABASE_URL=https://...
SUPABASE_ANON_KEY=eyJ...

# External Services
SLACK_BOT_TOKEN=xoxb-...
DISCORD_BOT_TOKEN=...
```

### セキュリティ考慮事項
1. **API Key管理**: 環境変数での管理、ローテーション
2. **CORS設定**: 適切なオリジン制限
3. **認証**: Firebase Auth / Supabase Auth統合
4. **監査ログ**: アクセス・操作ログの記録

## 次のステップ

1. 各ツールの基本セットアップ完了
2. 統合ワークフローの構築
3. 本格的なデモシナリオ作成
4. パフォーマンス最適化
5. 運用監視体制構築