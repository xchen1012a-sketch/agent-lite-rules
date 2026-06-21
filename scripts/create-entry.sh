#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
PROJECT_ROOT=""
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    *) PROJECT_ROOT="$arg" ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPEC_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -z "$PROJECT_ROOT" ]; then
  if [ "$(basename "$SPEC_ROOT")" = ".ai-spec" ]; then
    PROJECT_ROOT="$(cd "$SPEC_ROOT/.." && pwd)"
  elif [ -d "$(pwd)/.ai-spec" ]; then
    PROJECT_ROOT="$(pwd)"
  else
    PROJECT_ROOT="$(pwd)"
  fi
else
  PROJECT_ROOT="$(cd "$PROJECT_ROOT" && pwd)"
fi

if [ ! -d "$PROJECT_ROOT/.ai-spec" ]; then
  echo "Cannot find .ai-spec under project root: $PROJECT_ROOT" >&2
  exit 1
fi

available_target() {
  local path="$1"
  if [ ! -e "$path" ]; then
    printf '%s' "$path"
    return
  fi
  if [ ! -e "$path.proposed" ]; then
    printf '%s' "$path.proposed"
    return
  fi
  printf '%s' "$path.proposed-$(date +%Y%m%d-%H%M%S)"
}

write_file() {
  local path="$1"
  local content="$2"
  local target
  target="$(available_target "$path")"
  if [ "$DRY_RUN" = "1" ]; then
    echo "DRYRUN $target"
    return
  fi
  printf '%s\n' "$content" > "$target"
  echo "WROTE $target"
}

CLAUDE_CONTENT='# Claude Code 入口

本项目规则位于 `.ai-spec/`。

请先读取 `.ai-spec/.ai-rules/README.md`，再按任务等级读取：
- `.ai-spec/.ai-rules/task-routing.md`
- `.ai-spec/.ai-rules/context-loading.md`
- 命中的 `.ai-spec/skills/*/SKILL.md`

命中红线、安全、权限、外部服务、全局配置时读取：
- `.ai-spec/.ai-rules/redlines.md`

只使用当前项目规则。不得写入或修改用户全局 Claude / Codex 配置、全局 rules、全局 skills、全局 hooks 或全局 MCP。

不要默认全量读取 `.ai-spec/`。'

AGENTS_CONTENT='# Codex 入口

本项目规则位于 `.ai-spec/`。

Codex 必须先遵守系统/开发者指令，再读取：
- `.ai-spec/.ai-rules/README.md`
- `.ai-spec/.ai-rules/task-routing.md`
- `.ai-spec/.ai-rules/context-loading.md`
- 命中的 `.ai-spec/skills/*/SKILL.md`

命中红线、安全、权限、外部服务、全局配置时读取：
- `.ai-spec/.ai-rules/redlines.md`

只使用当前项目规则。不得写入或修改用户全局 Claude / Codex 配置、全局 rules、全局 skills、全局 hooks 或全局 MCP。

不要默认全量读取 `.ai-spec/`。'

write_file "$PROJECT_ROOT/CLAUDE.md" "$CLAUDE_CONTENT"
write_file "$PROJECT_ROOT/AGENTS.md" "$AGENTS_CONTENT"