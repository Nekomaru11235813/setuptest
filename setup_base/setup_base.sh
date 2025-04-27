#!/bin/bash

# requirements
# lsb_release : 22.04.5 LTS
# bash --version : 5.1.16(1)-release
# node --version : v20.18.0
# git --version : 2.34.1
# jq --version : 1.6

set -euo pipefail
IFS=$'\n\t'

# Pathの整理
ROOT_DIR=$(pwd) # プロジェクトのルート
SCRIPT_PATH="$(realpath "$0")" # スクリプトの絶対パス
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")" # スクリプトのディレクトリ
PROJECTS_DIR="${ROOT_DIR}/projects" # プロジェクトを吐き出すディレクトリ

# 引数の取得
ProjectName=${1:-"my_project"}

# プロジェクトの作成
AuthorName="blood"
mkdir -p "${PROJECTS_DIR}/${ProjectName}"
cd "${PROJECTS_DIR}/${ProjectName}" || exit 1

npm init -y --init-author-name "${AuthorName}"

# TypeScriptのインストール
npm install --save-dev typescript @types/node ts-node
npm install --save-dev jest ts-jest @types/jest 

# ディレクトリの作成
mkdir -p src dist 
mkdir -p memo
mkdir -p .vscode

# 初期ファイルの作成
touch src/index.ts src/index.test.ts 
touch README.md memo/working_memo.md
touch .vscode/settings.json .gitignore

echo "
const message: string = 'Hello, world!'; 
console.log(message);
" > src/index.ts

echo "
test('test', () => {
  expect(true).toBe(true);
});
" > src/index.test.ts

echo "# ${ProjectName}" > README.md
echo "# 作業メモ" > memo/working_memo.md

printf '{
  "editor.semanticHighlighting.enabled": true,
   "javascript.updateImportsOnFileMove.enabled": "always",
  "typescript.updateImportsOnFileMove.enabled": "always",
  "github.copilot.editor.enableAutoCompletions": true,
  "github.copilot.enable": {
    "*": true,
    "plaintext": false,
    "markdown": false,
    "scminput": false
  },
  "window.zoomLevel": -2,
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2,
    "editor.formatOnSave": true
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2,
    "editor.formatOnSave": true
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2,
    "editor.formatOnSave": true
  },
  "files.eol": "\n",
   "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
   "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
}' > .vscode/settings.json

printf "
node_modules/
dist/
coverage/
memo/
" > .gitignore

# configファイルの作成
cp "${SCRIPT_DIR}/tsconfig.template.json" tsconfig.json -f
cp "${SCRIPT_DIR}/jest.config.template.cjs" jest.config.cjs -f
cp "${SCRIPT_DIR}/.prettierrc" .prettierrc -f
cp "${SCRIPT_DIR}/eslint.config.js" eslint.config.js -f

# linter, formatter, huskyのインストール
npm install --save-dev eslint @eslint/js eslint-config-prettier prettier 
npm install --save-dev typescript-eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin 
npm install --save-dev husky lint-staged

# package.jsonの修正
jq '.scripts = {
  "start" : "node dist/index.js",
  "build" : "tsc",
  "start:ts": "ts-node src/index.ts",
  "test" : "jest",
  "lint" : "eslint src/**/*.ts",
  "lint:fix" : "eslint src/**/*.ts --fix && prettier --write src/**/*.ts"
}
| .type = "module"
| .husky = {
  "hooks": {
    "pre-commit": "lint-staged"
  }
}
| .["lint-staged"] = {
  "src/**/*.ts": [
    "npm run lint:fix"
  ]
}' package.json > temp.json && mv temp.json package.json

# linter, formatterの実行
npm run lint:fix
npm run lint
npm run build

npm start
npm run test

# gitの初期化
git init
git add .
git commit -m "init"
git branch -M main
git checkout -b feature
# git remote add origin

code .

cd "${PROJECTS_DIR}"







