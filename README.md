# agent-lite-rules

面向 Claude Code 和 Codex 的项目级「轻规则 + 强 Skills」模板。

仓库：`https://github.com/xchen1012a-sketch/agent-lite-rules`

## 核心结构

推荐把本仓库拉到目标项目的 `.ai-spec/`：

```text
项目根目录/
├── CLAUDE.md   -> Claude Code 根入口指针
├── AGENTS.md   -> Codex 根入口指针
└── .ai-spec/   -> 本模板
    ├── .ai-rules/ -> 唯一共享规则源
    ├── skills/    -> 唯一共享能力源
    ├── docs/      -> 示例或项目文档
    └── scripts/   -> 项目脚本占位
```

原则：入口只做指针，规则只放 `.ai-spec/.ai-rules`，能力只放 `.ai-spec/skills`，`docs/` 默认不读。

代码和输出必须模块化：代码按职责、边界和可测试性拆分；报告按结论、变更、验证、风险和下一步拆分。


## 项目级限定

本模板只做项目级规则，不接管用户本地或全局环境。

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
## 拉取模板

PowerShell / CMD / Bash：

```bash
git clone https://github.com/xchen1012a-sketch/agent-lite-rules.git .ai-spec
```

不要 clone 到 `~/.claude/`、`~/.codex/` 或任何全局配置目录。

## 创建项目入口

确认当前目录就是单仓项目或具体子仓后，还需要在该项目根目录创建 `CLAUDE.md` 和 `AGENTS.md`。否则 Claude Code / Codex 不一定会自动读取 `.ai-spec/` 里的入口文件。

不想手动创建时，直接运行脚本。脚本只创建当前项目入口；如果已有同名文件，会生成 `.proposed`，不会覆盖。

注意：如果 `.ai-spec/` 是临时拉到多子仓父目录的，不要直接运行本脚本。先看“父目录拉取后交给 AI 判断”，由 AI 根据项目结构决定父目录只保留路由入口，还是把规则接入具体子仓。

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

根目录 `CLAUDE.md`：

```md
# Claude Code 入口

本项目规则位于 `.ai-spec/`。

请先读取 `.ai-spec/.ai-rules/README.md`，再按任务等级读取：
- `.ai-spec/.ai-rules/task-routing.md`
- `.ai-spec/.ai-rules/context-loading.md`
- 命中的 `.ai-spec/skills/*/SKILL.md`

命中红线、安全、权限、外部服务、全局配置时读取：
- `.ai-spec/.ai-rules/redlines.md`

只使用当前项目规则。不得写入或修改用户全局 Claude / Codex 配置、全局 rules、全局 skills、全局 hooks 或全局 MCP。

不要默认全量读取 `.ai-spec/`。
```

根目录 `AGENTS.md`：

```md
# Codex 入口

本项目规则位于 `.ai-spec/`。

Codex 必须先遵守系统/开发者指令，再读取：
- `.ai-spec/.ai-rules/README.md`
- `.ai-spec/.ai-rules/task-routing.md`
- `.ai-spec/.ai-rules/context-loading.md`
- 命中的 `.ai-spec/skills/*/SKILL.md`

命中红线、安全、权限、外部服务、全局配置时读取：
- `.ai-spec/.ai-rules/redlines.md`

只使用当前项目规则。不得写入或修改用户全局 Claude / Codex 配置、全局 rules、全局 skills、全局 hooks 或全局 MCP。

不要默认全量读取 `.ai-spec/`。
```

如果目标项目已有同名文件，不要覆盖，先生成 `.proposed` 文件让用户确认。

## 父目录拉取后交给 AI 判断

如果先把模板拉到父目录 `.ai-spec/`，不要自己手动搬规则。先把下面提示词发给 AI，让 AI 判断走“空项目计划”还是“已有项目接入”：

```text
我已经在父目录拉取了 .ai-spec。

请先判断当前目录是空项目、新项目草稿，还是已有项目。

如果是空项目或新项目草稿：不要接入规则、不要创建文件、不要初始化 Git，先进入“空项目先做计划”流程，等我确认计划后再决定单仓还是多子仓并接入 .ai-spec。

如果是已有项目：进入“已有项目接入”流程，先只读盘点并输出接管报告，等我确认后再接入。

无论哪种情况：不写用户全局 Claude/Codex 配置；不覆盖已有文件，冲突生成 .proposed；不初始化父目录 Git；多子仓时 Git 只属于各子仓；不安装依赖、不写业务代码。
```

## 空项目先做计划

```text
我想做一个新项目，想法是：
【写你的项目想法】

请先不要创建文件、不要初始化 Git、不要安装依赖、不要写代码。

请先输出完整项目计划书，包括：项目名称、产品/业务域、核心模块词表、仓库/子仓命名、阶段编号前缀、项目目标、核心功能、推荐技术栈、项目目录草图、单项目还是多子仓建议、第一阶段交付目标、验收标准、需要我确认的问题。

等我确认后，再接入 .ai-spec。
```

确认计划后：

```text
我确认刚才的项目计划，可以开始执行。

要求：这是新项目流程。请先生成 docs/plans/project-plan.md、docs/plans/current.md 和 docs/plans/phases/*.md；计划里必须固化项目名称、模块词表、仓库/子仓命名、阶段前缀和项目目录草图；再按确认后的单仓或多子仓结构接入 .ai-spec；不创建 remote、不 push、不自动提交；已有同名文件生成 .proposed，不覆盖；不安装依赖、不写业务代码；完成后输出接入报告。
```

## 执行已确认计划

```text
我确认计划，可以开始执行当前阶段。

请先读取 docs/plans/project-plan.md 和 docs/plans/current.md，只执行 current 指向的当前阶段。执行前先报告当前阶段目标、范围、不做事项、验收标准和计划修改的文件。不要同时推进多个阶段；遇到计划外文件先报告，等我确认。
```

## 已有项目接入

```text
请使用父目录的 .ai-spec 接入当前已有项目。

要求：这是老项目流程。先只读盘点当前目录结构、技术栈、已有 AI 规则、已有 docs/plans、scripts、Git 状态、关键入口文件；不要创建文件、不要初始化 Git、不要安装依赖、不要启动服务、不要修改业务代码、不要写用户全局 Claude / Codex 配置。请输出老项目接管报告，包括：项目事实、已有规则冲突、单仓/多仓判断、建议接入位置、是否需要新增或合并计划、风险、需要我确认的问题。
```

老项目确认接入后：

```text
我确认老项目接管报告，可以按建议接入。

要求：优先沿用已有计划；没有计划再生成 docs/plans/project-plan.md、docs/plans/current.md 和 docs/plans/phases/*.md；在项目根目录生成 CLAUDE.md 和 AGENTS.md 指向 .ai-spec；不覆盖任何现有文件，冲突文件生成 .proposed；不修改业务代码；不安装依赖；不启动服务；无 Git 时不自动初始化；完成后输出接入报告。
```

## 更新模板

PowerShell / CMD / Bash：

```bash
git -C .ai-spec status --short
git -C .ai-spec pull --ff-only
```

同步到项目时先检查，不直接覆盖：

```text
父目录的 .ai-spec 已更新。请只读检查当前项目规则是否需要同步。

要求：对比模板和当前项目根目录 CLAUDE.md、AGENTS.md、.ai-spec/.ai-rules/、.ai-spec/skills/；不覆盖任何文件；不修改业务代码；如需更新，生成 .proposed 文件；输出差异报告和建议。
```

确认后应用：

```text
请应用我确认过的规则更新 proposed 文件。只替换我确认过的文件；不改业务代码；不改用户全局 Claude / Codex 配置；替换后输出更新报告。
```

## 换 AI 接管项目

```text
当前项目已经接入「轻规则 + 强 Skills」。

请按以下顺序接管：先读 CLAUDE.md 或 AGENTS.md；再读 .ai-spec/.ai-rules/README.md；再读 .ai-spec/.ai-rules/task-routing.md 和 .ai-spec/.ai-rules/context-loading.md；根据任务只读取 0-2 个相关 .ai-spec/skills；docs/ 默认不读，除非任务涉及计划、契约、验收或回归；先报告任务等级、需要读取的文件和下一步，不要直接改代码。
```


## Skill 优先级

默认使用 `project-first`：先用项目 `.ai-spec/skills/`，项目 skill 不足时才读取用户本地 skill 补充。

用户可以在提示词中切换：

```text
本项目本次任务使用 project-only，只读取项目 .ai-spec/skills，不读取用户本地 skills。
```

```text
本项目本次任务使用 local-first，可以优先使用我的本地 skills，但不得覆盖项目红线和契约。
```

```text
本项目恢复默认 project-first。项目 skills 优先，本地 skills 只在项目能力不足时补充。
```

无论哪种模式，都只允许读取需要的 skill，不允许修改用户全局 Claude / Codex 配置。

## 用户手册

`AI双工具全栈开发操作手册.md` 位于模板根目录，给用户查看；普通 AI 任务不要默认读取。




