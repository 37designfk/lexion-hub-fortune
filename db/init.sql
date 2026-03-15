-- 占いAI LINE Bot - conversations テーブル
-- 実行: docker exec postgres-37design psql -U n8n_37design -d uranai_ai -f /tmp/init.sql

CREATE TABLE IF NOT EXISTS conversations (
  id SERIAL PRIMARY KEY,
  line_user_id TEXT NOT NULL,
  role TEXT NOT NULL,          -- 'user' or 'assistant'
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_conv_user ON conversations(line_user_id, created_at);
