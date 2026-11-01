#!/usr/bin/env bash
set -euo pipefail
# OpenFilm 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/openfilm/openfilm#readme
# 更新日期：2026-11-01
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "需要先安装 Node.js"; exit 1; }

mkdir -p .download
cd .download

npx -y skills add openfilm/openfilm
npx -y openfilm@latest --help
echo "安装完成：让 agent 生成一条 20 秒短片，再在 Studio 里手改"

echo ""

echo "部署完成"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/openfilm/openfilm#readme"
