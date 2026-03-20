---
allowed-tools: Bash(git:*), Task
description: "ローカルの変更をcommit and push"
---

リポジトリの `.claude/agents/` 配下にコミット作成用のエージェント（例: `commit-creator.md`）が存在する場合は、そのエージェントに委譲してください。
存在しない場合は以下の手順で直接実行してください。

- ローカルの変更内容を確認
  - 変更がなければ終了
- 変更内容を確認してcommitする
  - commitルールはCLAUDE.mdを確認
  - 変更内容が多岐に渡る場合
    - 同じ内容の場合、commitをまとめる
    - 内容が異なる場合、commitを分ける
- commitが成功したらpushします

