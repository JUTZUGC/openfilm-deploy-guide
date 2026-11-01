# OpenFilm 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/openfilm/openfilm#readme
# 更新日期：2026-11-01
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw '需要先安装 Node.js' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

npx -y skills add openfilm/openfilm
npx -y openfilm@latest --help
Write-Host "安装完成：让 agent 生成一条 20 秒短片，再在 Studio 里手改"

Write-Host ''

Write-Host '部署完成'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/openfilm/openfilm#readme'
