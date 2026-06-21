# 规则索引

本目录是唯一共享规则源，只做索引。

## 路径说明

- 若模板安装在项目根目录，路径直接使用 `.ai-rules/` 和 `skills/`。
- 若模板安装在 `.ai-spec/`，所有路径以 `.ai-spec/` 为前缀。
- `AI双工具全栈开发操作手册.md` 位于模板根目录，给用户查看，普通 AI 任务不要默认读取。

## 文件索引

- `redlines.md`：不可突破红线。
- `task-routing.md`：判断任务等级和选择 skill。
- `context-loading.md`：决定最小读取范围。
- `documentation-policy.md`：什么时候更新文档。
- `git-workflow.md`：Git 分支、提交、MR/PR 和分仓提交规范。
- `modularity-output.md`：模块化代码、模块化文档和模块化交付输出规范。
- `project-facts.example.md`：项目事实模板；真实项目可另建 `project-facts.md`。

## 读取顺序

1. 先读 `task-routing.md`。
2. 再读 `context-loading.md`。
3. 命中风险时读 `redlines.md`。
4. 按任务类型读取 0-2 个相关 `skills/*/SKILL.md`。
5. 最后读取必要项目文件。

不要默认全量读取 `.ai-rules/`、`skills/`、`docs/`。

## 按需读取

- 涉及 Git、提交、分支、MR/PR 时读取 `git-workflow.md`。
- 涉及新增模块、多文件实现、重构、报告输出结构时读取 `modularity-output.md`。
- 用户询问双工具协作、全栈流程、Handoff 时读取模板根目录 `AI双工具全栈开发操作手册.md`。
- 普通开发任务不要默认读取操作手册。
