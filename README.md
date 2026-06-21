# agent-lite-rules

项目级「轻规则 + 强 Skills」模板，面向 Claude Code 和 Codex。

仓库：`https://github.com/xchen1012a-sketch/agent-lite-rules`

## 1. 用途

把 AI 协作规则放进当前项目，让 AI 先按项目规则、项目事实和项目 skills 工作，再按需补充全局能力。

核心原则：

- 项目优先：全局 rules 只能做背景，不能覆盖当前项目 `.ai-spec/`。
- 少读上下文：不默认全量读取 `.ai-spec/`、`skills/`、`docs/`。
- 事实分层：`project-facts.md` 的 `[auto]` 可刷新，`[manual]` 由人维护。
- 分阶段执行：L2+ bugfix / review-fix 先写 Markdown 阶段计划。
- 不碰全局：不写用户全局 Claude / Codex 配置、rules、skills、hooks、MCP。

## 2. 目录

推荐安装到目标项目的 `.ai-spec/`：

```text
项目根目录/
├── CLAUDE.md
├── AGENTS.md
└── .ai-spec/
    ├── .ai-rules/     # 任务路由、上下文、红线、Git、输出规则
    ├── skills/        # 项目优先 skills
    ├── docs/          # 计划、契约、验收示例
    └── scripts/       # 接入和检查脚本
```

关键文件：

- `.ai-rules/README.md`：规则索引。
- `.ai-rules/task-routing.md`：任务等级、skill 路由、全局规则边界。
- `.ai-rules/context-loading.md`：最小上下文和 `project-facts` 刷新规则。
- `.ai-rules/redlines.md`：安全、权限、外部服务、全局配置红线。
- `skills/project-domain/SKILL.md`：把通用规则落到当前项目事实和模块词表。

## 3. 接入

在目标项目根目录执行：

```bash
git clone https://github.com/xchen1012a-sketch/agent-lite-rules.git .ai-spec
```

创建 `CLAUDE.md` / `AGENTS.md`：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .ai-spec\scripts\create-entry.ps1
```

脚本不会覆盖已有入口文件；冲突时生成 `.proposed`。

## 4. AI 启动顺序

1. 读项目根目录 `CLAUDE.md` 或 `AGENTS.md`。
2. 读 `.ai-spec/.ai-rules/README.md`。
3. 读 `.ai-spec/.ai-rules/task-routing.md`。
4. 读 `.ai-spec/.ai-rules/context-loading.md`。
5. 运行 `.ai-spec/scripts/refresh-project-facts.ps1` 检查并刷新 `[auto]` 项目事实。
6. 按任务只读 0-2 个相关 `skills/*/SKILL.md`。
7. 命中安全、权限、外部服务、全局配置时，再读 `redlines.md`。

L2+ 任务最终必须说明读取了哪些项目 rules / skills；如果命中项目 skill 但读取数量为 0，必须重新路由。

## 5. 常用命令

刷新项目事实：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .ai-spec\scripts\refresh-project-facts.ps1
```

检查模板：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .ai-spec\scripts\check.ps1
```

更新模板：

```bash
git -C .ai-spec status --short
git -C .ai-spec pull --ff-only
```

## 6. 使用提示

新项目先做计划，确认后再生成 `docs/plans/project-plan.md`、`docs/plans/current.md` 和 `docs/plans/phases/*.md`。

已有项目先只读盘点，输出接管报告；确认前不改业务代码、不初始化 Git、不安装依赖、不启动服务。

bugfix / review-fix 达到 L2 及以上时，先写 `docs/plans/phases/FIX-*.md` 或 `REV-*.md`，再按阶段修复和验证。

`project-facts.md`：

- `[auto]`：依赖、脚本、目录、环境变量 key、Git 状态，由脚本刷新。
- `[manual]`：项目定位、业务域、模块词表、阶段前缀、安全边界，由人维护。

## 7. 边界

允许写当前项目：

- `CLAUDE.md`
- `AGENTS.md`
- `.ai-spec/`
- 已确认需要的 `docs/`、`scripts/`

禁止写或改：

- `~/.claude/`
- `~/.codex/`
- 全局 rules、skills、hooks、MCP
- 未确认的业务代码、生产配置、密钥文件
