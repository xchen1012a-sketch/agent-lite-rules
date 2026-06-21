# agent-lite-rules

面向 Claude Code 和 Codex 的项目级「轻规则 + 强 Skills」模板。

仓库：`https://github.com/xchen1012a-sketch/agent-lite-rules`

## 1. 这个模板解决什么

本模板只做一件事：把 AI 协作规则放进当前项目，让 Claude Code / Codex 先按项目规则工作，再按任务需要读取少量 skill。

核心原则：

- 入口轻：项目根目录只放 `CLAUDE.md` / `AGENTS.md` 指针。
- 规则轻：共享规则集中在 `.ai-spec/.ai-rules/`。
- 能力强：具体任务能力放在 `.ai-spec/skills/`。
- 上下文少：不默认全量读取规则、skills、docs。
- 不碰全局：不写用户全局 Claude / Codex 配置。

## 2. 推荐目录结构

推荐把本仓库放到目标项目的 `.ai-spec/`：

```text
项目根目录/
├── CLAUDE.md             # Claude Code 入口，指向 .ai-spec
├── AGENTS.md             # Codex 入口，指向 .ai-spec
└── .ai-spec/
    ├── .ai-rules/        # 项目共享规则
    ├── skills/           # 项目共享 skills
    ├── docs/             # 示例或项目文档，默认不读
    └── scripts/          # 接入脚本和辅助脚本
```

目录职责：

- `.ai-rules/README.md`：规则索引。
- `.ai-rules/task-routing.md`：判断任务等级和 skill。
- `.ai-rules/context-loading.md`：决定最小上下文。
- `.ai-rules/redlines.md`：安全、权限、全局配置等红线。
- `skills/*/SKILL.md`：按任务读取的具体能力说明。
- `AI双工具全栈开发操作手册.md`：给用户看的手册，普通任务不要默认读取。

## 3. 快速接入

在目标项目根目录执行：

```bash
git clone https://github.com/xchen1012a-sketch/agent-lite-rules.git .ai-spec
```

然后创建项目入口文件。推荐用脚本，脚本不会覆盖已有 `CLAUDE.md` / `AGENTS.md`，冲突时会生成 `.proposed`。

PowerShell：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .ai-spec\scripts\create-entry.ps1
```

CMD：

```cmd
.ai-spec\scripts\create-entry.cmd
```

Bash：

```bash
bash .ai-spec/scripts/create-entry.sh
```

接入完成后，项目根目录应该至少有：

```text
CLAUDE.md
AGENTS.md
.ai-spec/
```

## 4. AI 每次任务怎么读

Claude Code / Codex 接管任务时，按这个顺序读取：

1. 先读项目根目录 `CLAUDE.md` 或 `AGENTS.md`。
2. 再读 `.ai-spec/.ai-rules/README.md`。
3. 再读 `.ai-spec/.ai-rules/task-routing.md`。
4. 再读 `.ai-spec/.ai-rules/context-loading.md`。
5. 根据任务只读取 0-2 个相关 `skills/*/SKILL.md`。
6. 命中安全、权限、外部服务、全局配置时，再读 `.ai-spec/.ai-rules/redlines.md`。

不要默认全量读取 `.ai-spec/`、`skills/`、`docs/`。

## 5. 常用流程

### 5.1 空项目先做计划

适合只有想法、还没有正式项目结构的场景。

发给 AI：

```text
我想做一个新项目，想法是：【写你的项目想法】

请先不要创建文件、不要初始化 Git、不要安装依赖、不要写代码。
先输出项目计划书，包括项目名称、核心模块、仓库结构、技术栈、阶段规划、第一阶段目标、验收标准和需要我确认的问题。
等我确认后，再接入 .ai-spec。
```

确认后再发：

```text
我确认项目计划，可以开始执行。

这是新项目流程。请先生成 docs/plans/project-plan.md、docs/plans/current.md 和 docs/plans/phases/*.md，再按确认后的仓库结构接入 .ai-spec。
不创建 remote、不 push、不自动提交；已有同名文件生成 .proposed；不安装依赖、不写业务代码。
```

### 5.2 已有项目接入

适合项目已经存在，只想让 AI 规则接管。

先发：

```text
请使用 .ai-spec 接入当前已有项目。

先只读盘点当前目录结构、技术栈、已有 AI 规则、已有 docs/plans、scripts、Git 状态和关键入口文件。
不要创建文件、不要初始化 Git、不要安装依赖、不要启动服务、不要修改业务代码、不要写用户全局 Claude / Codex 配置。
请输出老项目接管报告。
```

确认后再发：

```text
我确认老项目接管报告，可以按建议接入。

优先沿用已有计划；没有计划再生成 docs/plans/project-plan.md、docs/plans/current.md 和 docs/plans/phases/*.md。
在项目根目录生成 CLAUDE.md 和 AGENTS.md 指向 .ai-spec；不覆盖现有文件，冲突生成 .proposed；不改业务代码；不安装依赖；不启动服务。
```

### 5.3 执行当前阶段

```text
我确认计划，可以开始执行当前阶段。

请先读取 docs/plans/project-plan.md 和 docs/plans/current.md，只执行 current 指向的当前阶段。
执行前先报告当前阶段目标、范围、不做事项、验收标准和计划修改的文件。
不要同时推进多个阶段；遇到计划外文件先报告，等我确认。
```

### 5.4 换 AI 接管

```text
当前项目已经接入「轻规则 + 强 Skills」。

请按以下顺序接管：先读 CLAUDE.md 或 AGENTS.md；再读 .ai-spec/.ai-rules/README.md；再读 .ai-spec/.ai-rules/task-routing.md 和 .ai-spec/.ai-rules/context-loading.md；根据任务只读取 0-2 个相关 .ai-spec/skills；docs/ 默认不读。
先报告任务等级、需要读取的文件和下一步，不要直接改代码。
```

## 6. 更新模板

检查模板状态：

```bash
git -C .ai-spec status --short
git -C .ai-spec pull --ff-only
```

同步到项目时，不要直接覆盖，让 AI 先只读对比：

```text
.ai-spec 已更新。请只读检查当前项目规则是否需要同步。

对比模板和当前项目根目录 CLAUDE.md、AGENTS.md、.ai-spec/.ai-rules/、.ai-spec/skills/。
不覆盖任何文件；不修改业务代码；如需更新，生成 .proposed 文件；输出差异报告和建议。
```

确认后再应用：

```text
请应用我确认过的规则更新 proposed 文件。
只替换我确认过的文件；不改业务代码；不改用户全局 Claude / Codex 配置；替换后输出更新报告。
```

## 7. 边界和红线

允许写入：

- 当前项目根目录 `CLAUDE.md`
- 当前项目根目录 `AGENTS.md`
- 当前项目 `.ai-spec/`
- 当前项目内确认需要的 `docs/`、`scripts/`

禁止写入或修改：

- `~/.claude/`
- `~/.codex/`
- `%USERPROFILE%\.claude/`
- `%USERPROFILE%\.codex/`
- 全局 rules、全局 skills、全局 hooks、全局 MCP 配置

用户本地 skills 只能按需读取作为补充，不能自动复制、安装、覆盖或修改。

## 8. Skill 优先级

默认使用 `project-first`：

1. 先用项目 `.ai-spec/skills/`。
2. 项目 skill 不足时，才读取用户本地 skill 补充。
3. 本地 skill 不能覆盖项目红线、契约、任务等级和验证要求。

可在提示词里临时切换：

```text
本项目本次任务使用 project-only，只读取项目 .ai-spec/skills，不读取用户本地 skills。
```

```text
本项目本次任务使用 local-first，可以优先使用我的本地 skills，但不得覆盖项目红线和契约。
```

```text
本项目恢复默认 project-first。项目 skills 优先，本地 skills 只在项目能力不足时补充。
```
