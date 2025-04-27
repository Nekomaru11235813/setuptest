# setup_base

TypeScriptプロジェクトを簡単に初期化するスクリプトです。

開発・検証に必要な実行環境、コードチェックツール、テスト環境をまとめて用意します。

## 必要環境

- Ubuntu 22.04.5 LTS
- bash 5.1.16
- Node.js 20.18.0
- git 2.34.1
- jq 1.6

## セットアップ手順

```bash
bash setup_base/setup_base.sh <プロジェクト名>d
```
プロジェクト名を省略すると my_project が作成されます。

## 主に導入されるもの
- TypeScript実行環境（ts-node, tsc）
- テスト環境（Jest）
- コード整形・Lintツール（ESLint, Prettier）
- Gitリポジトリ初期化
- VSCode用の設定ファイル群

## 特記事項
- src/index.ts に最小限のサンプルコードが生成されます。
- src/index.test.ts にJestのサンプルテストが生成されます。
- 生成されたプロジェクトはすぐにビルド・テストが可能です。
- プリコミットフック（husky + lint-staged）により、コミット前のコード整形とLintチェックが行われます。
- "code"によるVSCode起動が有効な場合、プロジェクト作成後VSCodeが自動起動します