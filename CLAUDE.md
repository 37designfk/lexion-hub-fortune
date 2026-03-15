# Lexion Hub Fortune

占いAI LINE Bot「さくら」+ 判断傾向レポート生成

## アーキテクチャ

```
LINE → n8n-37design (uranai-line webhook) → Claude API → LINE Reply
                ↓
          PostgreSQL (uranai_ai.conversations)
```

## 構成

| コンポーネント | 場所 |
|---|---|
| n8n ワークフロー (LINE Bot) | `n8n/uranai-line.json` |
| n8n ワークフロー (レポート) | `n8n/lexion-hub-fortune-workflow.json` |
| DB スキーマ | `db/init.sql` |
| さくらプロンプト | n8n ワークフロー内 (system メッセージ) |
| レポートプロンプト | `prompts/system-prompt.md` |

## 環境変数 (n8n-37design)

- `LINE_CHANNEL_SECRET`
- `LINE_CHANNEL_ACCESS_TOKEN`
- `ANTHROPIC_API_KEY`

## DB

- ホスト: postgres-37design (1号機 Docker)
- データベース: `uranai_ai`
- ユーザー: `n8n_37design`
- テーブル: `conversations` (line_user_id, role, message, created_at)

## デプロイ

### DB 初期化
```bash
ssh u "docker exec postgres-37design psql -U n8n_37design -c 'CREATE DATABASE uranai_ai;'"
ssh u "docker cp ~/lexion-hub-fortune/db/init.sql postgres-37design:/tmp/init.sql && docker exec postgres-37design psql -U n8n_37design -d uranai_ai -f /tmp/init.sql"
```

### n8n ワークフローインポート
```bash
ssh u "docker cp ~/lexion-hub-fortune/n8n/uranai-line.json n8n-37design:/tmp/uranai-line.json && docker exec n8n-37design n8n import:workflow --input=/tmp/uranai-line.json"
```

### n8n Credentials 設定 (手動)
- PostgreSQL: `uranai-ai-db` — host: postgres-37design, db: uranai_ai, user: n8n_37design
- ワークフローインポート後、n8n UI で Credentials を紐付ける

## LINE Developers

- Webhook URL: `https://n8n-37design.37d.jp/webhook/uranai-line`

## 検証

```bash
# DB 確認
ssh u "docker exec postgres-37design psql -U n8n_37design -d uranai_ai -c 'SELECT * FROM conversations ORDER BY created_at DESC LIMIT 10;'"
```
