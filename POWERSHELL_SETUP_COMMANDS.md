# PowerShell セットアップコマンド集

## 1. n8n セットアップ

### PowerShellで n8n 起動
```powershell
# n8nをnpx経由で起動
npx n8n

# または、グローバルインストール後起動
npm install -g n8n
n8n
```

**起動後：**
- ブラウザで http://localhost:5678 にアクセス
- 初回セットアップで管理者アカウント作成

### Dockerでの起動（Docker Desktopが必要）
```powershell
# データボリューム作成
docker volume create n8n_data

# n8nコンテナ起動
docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
```

## 2. dify セットアップ

### Git clone と起動
```powershell
# difyリポジトリをクローン
git clone https://github.com/langgenius/dify.git
cd dify

# Dockerで起動
cd docker
copy .env.example .env

# 環境変数編集（後で実行）
notepad .env

# Docker Compose起動
docker-compose up -d
```

**起動後：**
- フロントエンド: http://localhost:3000
- API: http://localhost:5001

### 環境変数の設定例
```powershell
# .env ファイルに追加する内容
@"
OPENAI_API_KEY=sk-your-openai-key-here
SECRET_KEY=your-secret-key-here
"@ | Out-File -FilePath .env -Encoding UTF8
```

## 3. Deep Research ツール（GPT Researcher）

### セットアップ
```powershell
# GPT Researcherクローン
git clone https://github.com/assafelovic/gpt-researcher.git
cd gpt-researcher

# 仮想環境作成（Python必要）
python -m venv venv
.\venv\Scripts\Activate.ps1

# 依存関係インストール
pip install -r requirements.txt

# 環境変数設定
copy .env.example .env
```

### 環境変数設定
```powershell
# .env ファイル作成
@"
OPENAI_API_KEY=sk-your-openai-key
TAVILY_API_KEY=tvly-your-tavily-key
LANGCHAIN_API_KEY=your-langchain-key
"@ | Out-File -FilePath .env -Encoding UTF8
```

### 起動
```powershell
# WebUI起動
python -m uvicorn main:app --host 0.0.0.0 --port 8000

# または
streamlit run main.py
```

## 4. OpenAI カスタマーサポートデモ

### リポジトリクローンとセットアップ
```powershell
# リポジトリクローン
git clone https://github.com/openai/openai-cs-agents-demo.git
cd openai-cs-agents-demo

# バックエンド環境設定
cd backend
copy .env.example .env

# 環境変数設定
@"
OPENAI_API_KEY=sk-your-openai-key
DATABASE_URL=sqlite:///./customer_support.db
"@ | Out-File -FilePath .env -Encoding UTF8

# Python仮想環境作成
python -m venv venv
.\venv\Scripts\Activate.ps1

# 依存関係インストール
pip install -r requirements.txt

# データベース初期化
python init_db.py

# バックエンド起動
python main.py
```

### フロントエンド起動（別のPowerShellウィンドウ）
```powershell
cd openai-cs-agents-demo\frontend

# Node.js依存関係インストール
npm install

# 環境変数設定
@"
REACT_APP_API_URL=http://localhost:8000
"@ | Out-File -FilePath .env -Encoding UTF8

# フロントエンド起動
npm start
```

**起動後：**
- フロントエンド: http://localhost:3000
- バックエンドAPI: http://localhost:8000

## 5. 統合ワークフロー例

### n8n + OpenAI デモワークフロー
```powershell
# n8n起動後、以下のワークフローを作成
# 1. Webhook Trigger
# 2. OpenAI Chat Model
# 3. HTTP Request (to Customer Support API)
# 4. Slack Message
```

## 6. Railway デプロイ準備

### Railway CLI インストール
```powershell
# Railway CLIインストール
npm install -g @railway/cli

# ログイン
railway login

# プロジェクト初期化
railway init

# 環境変数設定
railway variables set OPENAI_API_KEY=sk-your-key

# デプロイ
railway up
```

## 7. 便利なPowerShellスクリプト

### 全サービス起動スクリプト
```powershell
# start-all-demos.ps1
Write-Host "Starting all demo services..." -ForegroundColor Green

# n8n起動（バックグラウンド）
Start-Process powershell -ArgumentList "-Command", "npx n8n"

# Dify起動
Set-Location "C:\path\to\dify\docker"
Start-Process powershell -ArgumentList "-Command", "docker-compose up -d"

# Customer Support Demo起動
Set-Location "C:\path\to\openai-cs-agents-demo"
Start-Process powershell -ArgumentList "-Command", "cd backend; .\venv\Scripts\Activate.ps1; python main.py"
Start-Process powershell -ArgumentList "-Command", "cd frontend; npm start"

Write-Host "All services starting. Check browser tabs:" -ForegroundColor Yellow
Write-Host "- n8n: http://localhost:5678" -ForegroundColor Cyan
Write-Host "- dify: http://localhost:3000" -ForegroundColor Cyan
Write-Host "- Customer Support: http://localhost:3000" -ForegroundColor Cyan
```

### サービス停止スクリプト
```powershell
# stop-all-demos.ps1
Write-Host "Stopping all demo services..." -ForegroundColor Red

# Node.jsプロセス停止
Get-Process | Where-Object {$_.ProcessName -eq "node"} | Stop-Process -Force

# Python プロセス停止
Get-Process | Where-Object {$_.ProcessName -eq "python"} | Stop-Process -Force

# Docker停止
docker-compose down

Write-Host "All services stopped." -ForegroundColor Green
```

## 8. 必要な前提条件

### インストール確認
```powershell
# バージョン確認
Write-Host "=== System Check ===" -ForegroundColor Green
node --version
npm --version
python --version
docker --version
git --version

# 必要に応じてインストール
# Node.js: https://nodejs.org/
# Python: https://python.org/
# Docker Desktop: https://docker.com/products/docker-desktop/
# Git: https://git-scm.com/
```

## 9. トラブルシューティング

### ポート競合解決
```powershell
# ポート使用確認
netstat -ano | findstr :5678
netstat -ano | findstr :3000
netstat -ano | findstr :8000

# プロセス終了
taskkill /PID <PID番号> /F
```

### 仮想環境アクティベーション確認
```powershell
# 仮想環境がアクティブか確認
Get-Command python | Select-Object Source

# 手動でアクティベート
.\venv\Scripts\Activate.ps1
```

これらのコマンドで各デモアプリケーションを順次起動できます。まずはn8nから試してみてください！