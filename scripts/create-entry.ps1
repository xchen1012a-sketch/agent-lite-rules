param(
  [string]$ProjectRoot = "",
  [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-ProjectRoot {
  param([string]$ExplicitRoot)

  if ($ExplicitRoot) {
    return (Resolve-Path -LiteralPath $ExplicitRoot).Path
  }

  $cwd = (Get-Location).Path
  if (Test-Path -LiteralPath (Join-Path $cwd ".ai-spec")) {
    return $cwd
  }

  $specRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
  if ((Split-Path -Leaf $specRoot) -eq ".ai-spec") {
    return (Split-Path -Parent $specRoot)
  }

  return $cwd
}

function Get-AvailableTarget {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    return $Path
  }

  $proposed = "$Path.proposed"
  if (-not (Test-Path -LiteralPath $proposed)) {
    return $proposed
  }

  $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
  return "$Path.proposed-$stamp"
}

function Write-EntryFile {
  param(
    [string]$Path,
    [string]$Content
  )

  $target = Get-AvailableTarget -Path $Path

  if ($DryRun) {
    Write-Output "DRYRUN $target"
    return
  }

  Set-Content -LiteralPath $target -Encoding UTF8 -Value $Content
  Write-Output "WROTE $target"
}

$rootPath = Resolve-ProjectRoot -ExplicitRoot $ProjectRoot
$specPath = Join-Path $rootPath ".ai-spec"
if (-not (Test-Path -LiteralPath $specPath)) {
  throw "Cannot find .ai-spec under project root: $rootPath"
}

$claude = @"
# Claude Code 入口

本项目规则位于 ``.ai-spec/``。

请先读取 ``.ai-spec/.ai-rules/README.md``，再按任务等级读取：
- ``.ai-spec/.ai-rules/task-routing.md``
- ``.ai-spec/.ai-rules/context-loading.md``
- 命中的 ``.ai-spec/skills/*/SKILL.md``

命中红线、安全、权限、外部服务、全局配置时读取：
- ``.ai-spec/.ai-rules/redlines.md``

只使用当前项目规则。不得写入或修改用户全局 Claude / Codex 配置、全局 rules、全局 skills、全局 hooks 或全局 MCP。

不要默认全量读取 ``.ai-spec/``。
"@

$agents = @"
# Codex 入口

本项目规则位于 ``.ai-spec/``。

Codex 必须先遵守系统/开发者指令，再读取：
- ``.ai-spec/.ai-rules/README.md``
- ``.ai-spec/.ai-rules/task-routing.md``
- ``.ai-spec/.ai-rules/context-loading.md``
- 命中的 ``.ai-spec/skills/*/SKILL.md``

命中红线、安全、权限、外部服务、全局配置时读取：
- ``.ai-spec/.ai-rules/redlines.md``

只使用当前项目规则。不得写入或修改用户全局 Claude / Codex 配置、全局 rules、全局 skills、全局 hooks 或全局 MCP。

不要默认全量读取 ``.ai-spec/``。
"@

Write-EntryFile -Path (Join-Path $rootPath "CLAUDE.md") -Content $claude.TrimEnd()
Write-EntryFile -Path (Join-Path $rootPath "AGENTS.md") -Content $agents.TrimEnd()

