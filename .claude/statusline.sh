#!/bin/bash

input=$(cat)

# jqを使用して値を抽出
VERSION=$(echo "$input" | jq -r '.version')
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
DIR_BASENAME="${CURRENT_DIR##*/}"

# コンテキスト使用率を取得
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# gitリポジトリ内の場合はブランチ名を表示
GIT_INFO=""
if [ -d "$CURRENT_DIR" ]; then
    BRANCH=$(cd "$CURRENT_DIR" && git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_INFO=" | $BRANCH"
    fi
fi

# N225株価を取得（5分間キャッシュ）
N225=""
CACHE_FILE="/tmp/.claude_n225_cache"
CACHE_MAX_AGE=300  # 5分（秒）

# キャッシュが有効か確認
USE_CACHE=false
if [ -f "$CACHE_FILE" ]; then
    CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) ))
    if [ "$CACHE_AGE" -lt "$CACHE_MAX_AGE" ]; then
        USE_CACHE=true
    fi
fi

if [ "$USE_CACHE" = true ]; then
    STOCK_DATA=$(cat "$CACHE_FILE")
else
    STOCK_DATA=$(curl -s --max-time 3 "https://www.google.com/finance/quote/NI225:INDEXNIKKEI" -H "User-Agent: Mozilla/5.0" 2>/dev/null | python3 -c "
import sys, re
html = sys.stdin.read()
text = re.sub(r'<[^>]+>', '\n', html)
lines = [l.strip() for l in text.split('\n') if l.strip()]
for i, l in enumerate(lines):
    if re.match(r'^[\d,]+\.\d+$', l) and ',' in l and i > 3:
        price = l.split('.')[0]
        pct = lines[i+1] if i+1 < len(lines) else ''
        change = lines[i+2] if i+2 < len(lines) else ''
        print(f'N225:{price}({change}/{pct})')
        break
" 2>/dev/null)
    # 取得成功時のみキャッシュを更新
    if [ -n "$STOCK_DATA" ]; then
        echo "$STOCK_DATA" > "$CACHE_FILE"
    fi
fi

if [ -n "$STOCK_DATA" ]; then
    N225=" | $STOCK_DATA"
fi

# 次のカレンダー予定を取得（5分間キャッシュ）
NEXT_EVENT=""
CAL_CACHE_FILE="/tmp/.claude_cal_cache"
CAL_CACHE_MAX_AGE=300  # 5分

USE_CAL_CACHE=false
if [ -f "$CAL_CACHE_FILE" ]; then
    CAL_CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$CAL_CACHE_FILE" 2>/dev/null || echo 0) ))
    if [ "$CAL_CACHE_AGE" -lt "$CAL_CACHE_MAX_AGE" ]; then
        USE_CAL_CACHE=true
    fi
fi

if [ "$USE_CAL_CACHE" = true ]; then
    NEXT_EVENT=$(cat "$CAL_CACHE_FILE")
else
    NEXT_EVENT=$(gws calendar +agenda --today --calendar 'naoto.hamada@findy.co.jp' --format json 2>/dev/null | python3 -c "
import json, sys
from datetime import datetime, timezone, timedelta

JST = timezone(timedelta(hours=9))
now = datetime.now(JST)
data = json.load(sys.stdin)

for e in data.get('events', []):
    start = e.get('start', '')
    # 終日イベントはスキップ（T を含まない）
    if 'T' not in start:
        continue
    event_time = datetime.fromisoformat(start)
    if event_time > now:
        time_str = event_time.strftime('%H:%M')
        summary = e.get('summary', '')
        print(f'{time_str} {summary}')
        break
else:
    print('予定なし')
" 2>/dev/null)
    if [ -n "$NEXT_EVENT" ]; then
        echo "$NEXT_EVENT" > "$CAL_CACHE_FILE"
    fi
fi

CAL_INFO=""
if [ -n "$NEXT_EVENT" ]; then
    CAL_INFO=" | $NEXT_EVENT"
fi

# GitHub PR情報を取得（5分間キャッシュ）
GH_INFO=""
GH_CACHE_FILE="/tmp/.claude_gh_cache"
GH_CACHE_MAX_AGE=300  # 5分

USE_GH_CACHE=false
if [ -f "$GH_CACHE_FILE" ]; then
    GH_CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$GH_CACHE_FILE" 2>/dev/null || echo 0) ))
    if [ "$GH_CACHE_AGE" -lt "$GH_CACHE_MAX_AGE" ]; then
        USE_GH_CACHE=true
    fi
fi

if [ "$USE_GH_CACHE" = true ]; then
    GH_INFO=$(cat "$GH_CACHE_FILE")
else
    GH_INFO=$(gh api graphql -f query='
{
  review: search(query: "is:pr is:open review-requested:ham0215", type: ISSUE, first: 10) {
    issueCount
  }
  myPrs: search(query: "is:pr is:open author:ham0215", type: ISSUE, first: 20) {
    nodes {
      ... on PullRequest {
        number
        url
        reviewDecision
        mergeable
        isDraft
        commits(last: 1) {
          nodes {
            commit {
              statusCheckRollup {
                state
              }
            }
          }
        }
      }
    }
  }
}' 2>/dev/null | python3 -c "
import json, sys

data = json.load(sys.stdin)
review_count = data['data']['review']['issueCount']
my_prs = data['data']['myPrs']['nodes']

ci_map = {'SUCCESS': '✓', 'PENDING': '⏳', 'FAILURE': '✗', 'ERROR': '✗'}

# Review件数（クリッカブルリンク）
review_url = 'https://github.com/pulls/review-requested'
review_link = f'\033]8;;{review_url}\007Review\033]8;;\007:{review_count}'

def pr_status(pr):
    if pr.get('isDraft'):
        return 'draft'
    mg = pr.get('mergeable', '')
    if mg == 'CONFLICTING':
        return 'conflict'
    rd = pr.get('reviewDecision')
    if rd == 'CHANGES_REQUESTED':
        return '要修正'
    if rd == 'REVIEW_REQUIRED':
        return 'review'
    if mg == 'MERGEABLE' and rd == 'APPROVED':
        return 'mergeable'
    return '?'

pr_parts = []
for pr in my_prs:
    n = pr['number']
    url = pr['url']
    rollup = pr.get('commits', {}).get('nodes', [{}])[0].get('commit', {}).get('statusCheckRollup')
    ci = ci_map.get(rollup['state'], '?') if rollup else '-'
    status = pr_status(pr)
    link = f'\033]8;;{url}\007#{n}\033]8;;\007'
    pr_parts.append(f'{link}(CI:{ci} {status})')

if pr_parts:
    my_pr_str = 'My PR: ' + ' '.join(pr_parts)
else:
    my_pr_str = 'My PR:0'

print(f'{review_link} | {my_pr_str}')
" 2>/dev/null)
    if [ -n "$GH_INFO" ]; then
        echo "$GH_INFO" > "$GH_CACHE_FILE"
    fi
fi

printf "v%s [%s] | %s%s | ctx: %s%%%s\n" "$VERSION" "$MODEL_DISPLAY" "$DIR_BASENAME" "$GIT_INFO" "$PCT" "$N225"
# 2行目: GitHub情報
if [ -n "$GH_INFO" ]; then
    printf "%b\n" "$GH_INFO"
fi
# 3行目: カレンダー予定
if [ -n "$NEXT_EVENT" ]; then
    printf "%s\n" "$NEXT_EVENT"
fi

