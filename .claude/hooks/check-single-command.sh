#!/bin/bash
# PreToolUse hook: Bash コマンドの && による結合を検出してブロックする

# jq の存在チェック（安全側に倒す）
if ! command -v jq &> /dev/null; then
  cat <<'DENY_EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "jq がインストールされていません。フックの実行に必要です。"
  }
}
DENY_EOF
  exit 0
fi

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null)
JQ_EXIT=$?

# jq パース失敗時は安全側に倒して deny
if [ $JQ_EXIT -ne 0 ]; then
  cat <<'DENY_EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "フック入力のJSON解析に失敗しました。"
  }
}
DENY_EOF
  exit 0
fi

# 空コマンドは許可
if [ -z "$COMMAND" ]; then
  exit 0
fi

deny() {
  cat <<'DENY_EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "コマンドが && で結合されています。CLAUDE.md のルールに従い、コマンドは1つずつ個別に実行してください。"
  }
}
DENY_EOF
  exit 0
}

# クォート外に現れる &&（コマンド結合）を検出する
contains_unquoted_and_and() {
  local cmd=$1
  local len=${#cmd}
  local i
  local ch
  local prev_ch=''
  local in_single_quote=0
  local in_double_quote=0

  for ((i = 0; i < len; i++)); do
    ch=${cmd:i:1}

    # クォート状態の更新
    if [ "$ch" = "'" ] && [ $in_double_quote -eq 0 ]; then
      if [ $in_single_quote -eq 0 ]; then
        in_single_quote=1
      else
        in_single_quote=0
      fi
      prev_ch=$ch
      continue
    fi

    if [ "$ch" = '"' ] && [ $in_single_quote -eq 0 ]; then
      if [ $in_double_quote -eq 0 ]; then
        in_double_quote=1
      else
        in_double_quote=0
      fi
      prev_ch=$ch
      continue
    fi

    # クォート外で && が連続したら検出
    if [ $in_single_quote -eq 0 ] && [ $in_double_quote -eq 0 ]; then
      if [ "$ch" = "&" ] && [ "$prev_ch" = "&" ]; then
        return 0
      fi
    fi

    prev_ch=$ch
  done

  return 1
}

# && の検出（どのコマンドでも結合は禁止）
if contains_unquoted_and_and "$COMMAND"; then
  deny
fi

# git -C の検出（cd と git コマンドに分割すべき）
if echo "$COMMAND" | grep -qE '(^|[[:space:]])git[[:space:]]+-C[[:space:]]'; then
  # -C の引数（ディレクトリ）を抽出
  GIT_C_DIR=$(echo "$COMMAND" | sed -nE 's/.*git[[:space:]]+-C[[:space:]]+([^[:space:]]+).*/\1/p')
  cat <<DENY_EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "git -C フラグは使用禁止です。CLAUDE.md のルールに従い、「cd ${GIT_C_DIR}」と git コマンドを別々に実行してください。"
  }
}
DENY_EOF
  exit 0
fi

# 問題なし → 許可
exit 0
