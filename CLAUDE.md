# Claude Code 入口

本文件是模板内入口。若本模板安装在 `.ai-spec/`，项目根目录仍应有 `CLAUDE.md` 指向 `.ai-spec/`。

本项目使用「轻规则 + 强 Skills」结构。

## 启动方式

1. 先读 `.ai-rules/README.md`，确认规则位置。
2. 再读 `.ai-rules/task-routing.md`，判断任务等级。
3. 再读 `.ai-rules/context-loading.md`，决定最小上下文。
4. 按任务类型只读取 0-2 个相关 `skills/*/SKILL.md`。
5. 命中红线、安全、权限、外部服务、全局配置时读取 `.ai-rules/redlines.md`。
6. 不默认全量读取 `.ai-rules/`、`skills/`、`docs/`。

## 项目级限定

只使用当前项目规则。不得写入或修改用户全局 Claude / Codex 配置、全局 rules、全局 skills、全局 hooks 或全局 MCP。

## 输出

默认使用简体中文。修改后说明改了什么、验证了什么、未验证什么。
