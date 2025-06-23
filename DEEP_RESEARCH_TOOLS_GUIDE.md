# Deep Research系OSSツール 完全ガイド

## 概要

Deep Research（深度調査）系ツールは、AIを活用して大量の情報を収集・分析し、包括的なレポートを生成するツールです。従来の手動調査では数日かかる作業を数分～数時間で完了できます。

## 主要ツール比較

### 1. GPT Researcher
**GitHub**: https://github.com/assafelovic/gpt-researcher  
**特徴**: 最も人気の高いオープンソース研究エージェント

```
【強み】
- 50以上の情報源からの自動収集
- 偏見を排除した多角的分析
- カスタマイズ可能な研究フォーマット
- リアルタイムウェブスクレイピング

【技術スタック】
- Backend: Python, FastAPI
- Frontend: React, Next.js
- AI: OpenAI GPT-4, Claude
- Search: Tavily, SerpAPI, Google Search
```

### 2. Storm (Stanford)
**GitHub**: https://github.com/stanford-oval/storm  
**特徴**: スタンフォード大学開発の学術研究特化ツール

```
【強み】
- Wikipedia品質の記事生成
- 学術論文の自動引用
- 多段階の事実確認プロセス
- 構造化された研究アウトライン

【技術スタック】
- Backend: Python, Django
- AI: OpenAI GPT-4, Anthropic Claude
- Data: Wikipedia API, arXiv API
- Visualization: D3.js, Plotly
```

### 3. Perplexica
**GitHub**: https://github.com/ItzCrazyKns/Perplexica  
**特徴**: Perplexity AIのオープンソース代替

```
【強み】
- リアルタイム検索統合
- 対話型研究インターフェース
- ソース透明性の確保
- 多言語対応

【技術スタック】
- Backend: TypeScript, Node.js
- Frontend: React, TypeScript
- AI: OpenAI, Local LLMs
- Search: SearxNG, Brave Search
```

### 4. AutoGPT Research
**GitHub**: https://github.com/Significant-Gravitas/AutoGPT  
**特徴**: 自律型AIエージェントによる研究

```
【強み】
- 完全自律的な研究実行
- 長期記憶機能
- タスク分解と並列実行
- ツールの自動選択

【技術スタック】
- Backend: Python, SQLAlchemy
- AI: OpenAI GPT-4, Local LLMs
- Memory: Redis, PostgreSQL
- Tools: Web scraping, API integration
```

## セットアップ詳細（PowerShellコマンド）

### 1. GPT Researcher セットアップ

```powershell
# リポジトリクローン
git clone https://github.com/assafelovic/gpt-researcher.git
cd gpt-researcher

# 仮想環境作成
python -m venv venv
.\venv\Scripts\Activate.ps1

# 依存関係インストール
pip install -r requirements.txt

# 環境変数設定
@"
OPENAI_API_KEY=sk-your-openai-key
TAVILY_API_KEY=tvly-your-tavily-key
LANGCHAIN_API_KEY=lsv2_your-langchain-key
GOOGLE_API_KEY=your-google-api-key
GOOGLE_CX=your-custom-search-engine-id
SERPAPI_API_KEY=your-serpapi-key
"@ | Out-File -FilePath .env -Encoding UTF8

# フロントエンド依存関係
cd frontend
npm install

# 開発サーバー起動（2つのターミナル必要）
# Terminal 1: Backend
cd ..
python -m uvicorn main:app --host 0.0.0.0 --port 8000

# Terminal 2: Frontend
cd frontend
npm run dev
```

### 2. Storm セットアップ

```powershell
# リポジトリクローン
git clone https://github.com/stanford-oval/storm.git
cd storm

# 仮想環境作成
python -m venv venv
.\venv\Scripts\Activate.ps1

# 依存関係インストール
pip install -e .

# 設定ファイル作成
@"
{
  "OPENAI_API_KEY": "sk-your-openai-key",
  "ANTHROPIC_API_KEY": "sk-ant-your-anthropic-key",
  "WIKIPEDIA_API_ENDPOINT": "https://en.wikipedia.org/w/api.php",
  "OUTPUT_DIR": "./output"
}
"@ | Out-File -FilePath config.json -Encoding UTF8

# 使用例
python storm.py --topic "人工知能の歴史" --config config.json
```

### 3. Perplexica セットアップ

```powershell
# リポジトリクローン
git clone https://github.com/ItzCrazyKns/Perplexica.git
cd Perplexica

# Docker Compose使用（推奨）
copy sample.config.toml config.toml

# 設定編集
notepad config.toml

# Docker起動
docker-compose up -d

# または手動セットアップ
# Backend
cd backend
npm install
npm run build

# Frontend
cd ../frontend
npm install
npm run build

# 起動
cd ../backend
npm start
```

### 4. AutoGPT Research セットアップ

```powershell
# リポジトリクローン
git clone https://github.com/Significant-Gravitas/AutoGPT.git
cd AutoGPT

# 仮想環境作成
python -m venv venv
.\venv\Scripts\Activate.ps1

# 依存関係インストール
pip install -r requirements.txt

# 環境変数設定
copy .env.template .env
notepad .env  # API keys を設定

# データベース初期化
python scripts/setup_db.py

# AutoGPT起動
python main.py
```

## Railway デプロイ設定

### GPT Researcher - Railway デプロイ

```toml
# railway.toml
[build]
  builder = "NIXPACKS"
  buildCommand = "pip install -r requirements.txt"

[deploy]
  startCommand = "uvicorn main:app --host 0.0.0.0 --port $PORT"
  restartPolicyType = "ON_FAILURE"

[variables]
  OPENAI_API_KEY = "sk-your-key"
  TAVILY_API_KEY = "tvly-your-key"
```

### フロントエンド分離デプロイ

```powershell
# バックエンドデプロイ
railway new gpt-researcher-backend
railway up

# フロントエンドデプロイ（Vercel推奨）
cd frontend
npm run build
npx vercel --prod
```

## GCP CloudRun デプロイ

### Dockerfile例（GPT Researcher）

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
```

### デプロイコマンド

```powershell
# Google Cloud SDK設定
gcloud auth login
gcloud config set project 2025-bitgrit-demos

# Docker イメージビルド
docker build -t gcr.io/2025-bitgrit-demos/gpt-researcher .
docker push gcr.io/2025-bitgrit-demos/gpt-researcher

# CloudRun デプロイ
gcloud run deploy gpt-researcher `
  --image gcr.io/2025-bitgrit-demos/gpt-researcher `
  --platform managed `
  --region asia-northeast1 `
  --allow-unauthenticated `
  --set-env-vars OPENAI_API_KEY=sk-your-key
```

## 実践的な使用例

### 1. 市場調査レポート生成

```python
# GPT Researcher使用例
from gpt_researcher import GPTResearcher

# 調査テーマ設定
query = "2024年生成AI市場の動向と主要プレイヤー分析"

# 研究実行
researcher = GPTResearcher(query=query, report_type="research_report")
research_result = await researcher.conduct_research()
report = await researcher.write_report()

# レポート出力
with open("ai_market_2024.md", "w", encoding="utf-8") as f:
    f.write(report)
```

### 2. 競合分析

```python
# 複数企業の比較分析
companies = ["OpenAI", "Anthropic", "Google DeepMind", "Meta AI"]

for company in companies:
    query = f"{company}の2024年の事業戦略と技術動向"
    researcher = GPTResearcher(query=query, report_type="competitive_analysis")
    result = await researcher.conduct_research()
    
    # 結果を構造化データとして保存
    save_analysis(company, result)
```

### 3. 技術調査

```python
# 新技術の評価
tech_query = "Retrieval-Augmented Generation (RAG) の最新手法と実装方法"

researcher = GPTResearcher(
    query=tech_query,
    report_type="technical_analysis",
    source_urls=["arxiv.org", "github.com", "papers.with.code"],
    max_iterations=5
)

technical_report = await researcher.conduct_research()
```

## 活用シナリオ別設定

### 学術研究用設定

```python
# Storm設定（学術特化）
config = {
    "research_depth": "comprehensive",
    "citation_style": "APA",
    "fact_check_level": "strict",
    "sources": ["arxiv", "pubmed", "ieee", "acm"],
    "peer_review": True
}
```

### ビジネス調査用設定

```python
# GPT Researcher設定（ビジネス特化）
config = {
    "research_depth": "business_focused",
    "sources": ["financial_reports", "news", "company_websites"],
    "analysis_framework": "SWOT",
    "time_range": "last_12_months"
}
```

### 技術調査用設定

```python
# Perplexica設定（技術特化）
config = {
    "search_engines": ["github", "stackoverflow", "documentation"],
    "programming_languages": ["Python", "JavaScript", "Go"],
    "focus_areas": ["implementation", "best_practices", "performance"]
}
```

## パフォーマンス最適化

### 1. 並列処理設定

```python
# 複数クエリの並列実行
import asyncio

async def parallel_research(queries):
    tasks = []
    for query in queries:
        researcher = GPTResearcher(query=query)
        tasks.append(researcher.conduct_research())
    
    results = await asyncio.gather(*tasks)
    return results
```

### 2. キャッシュ戦略

```python
# Redis キャッシュ設定
import redis

cache = redis.Redis(host='localhost', port=6379, db=0)

def cached_research(query):
    cached_result = cache.get(f"research:{query}")
    if cached_result:
        return json.loads(cached_result)
    
    result = conduct_research(query)
    cache.setex(f"research:{query}", 3600, json.dumps(result))
    return result
```

### 3. コスト最適化

```python
# API使用量制御
config = {
    "max_tokens_per_request": 2000,
    "rate_limit_requests_per_minute": 10,
    "use_cheaper_models_for_initial_research": True,
    "upgrade_to_gpt4_for_final_report": True
}
```

## 統合ワークフロー例

### n8n + GPT Researcher 統合

```javascript
// n8n Custom Node Example
const research = await $node["GPT Researcher"].json;

// Slack通知
await $node["Slack"].execute({
    message: `調査完了: ${research.title}\n要約: ${research.summary}`,
    channel: "#research-updates"
});

// Google Driveに保存
await $node["Google Drive"].execute({
    name: `research_${Date.now()}.pdf`,
    content: research.full_report
});
```

### dify + Deep Research統合

```python
# dify ワークフロー内での活用
def research_workflow(user_query):
    # Step 1: 初期調査
    initial_research = gpt_researcher.quick_research(user_query)
    
    # Step 2: difyでの要約・構造化
    structured_output = dify_client.process({
        "input": initial_research,
        "task": "summarize_and_structure"
    })
    
    # Step 3: 追加調査の必要性判定
    if structured_output.needs_deeper_research:
        detailed_research = gpt_researcher.deep_research(
            user_query,
            focus_areas=structured_output.focus_areas
        )
        return detailed_research
    
    return structured_output
```

## トラブルシューティング

### よくある問題と解決策

```powershell
# 1. API Rate Limit エラー
# 解決策: リクエスト間隔の調整
$env:RATE_LIMIT_DELAY = "2"  # 2秒間隔

# 2. メモリ不足エラー
# 解決策: バッチサイズの削減
$env:BATCH_SIZE = "5"

# 3. 日本語検索結果の質向上
# 解決策: 検索エンジンの言語設定
$env:SEARCH_LANGUAGE = "ja"
$env:SEARCH_REGION = "JP"
```

### ログレベル設定

```python
import logging

# デバッグ用設定
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('research.log'),
        logging.StreamHandler()
    ]
)
```

これらのツールを適切に設定・運用することで、研究・調査業務の大幅な効率化が可能になります。特にGPT Researcherは設定が簡単で、即座に実用的な結果が得られるため、最初の導入におすすめです。