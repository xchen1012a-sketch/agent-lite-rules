# Git 提交规范

本文件只在涉及 Git、分支、提交、MR/PR、交接时读取。普通开发任务不要默认读取。

## 基本原则

- 不自动 `git add` / `git commit` / `git push`，除非用户明确要求。
- 提交前必须先看 `git status` 和相关 `git diff`。
- 只提交本次任务相关文件，不夹带无关改动。
- 不提交密钥、Token、私钥、证书、真实生产配置。
- 不为了提交而跳过测试或隐藏失败。
- 不在父目录误提交子仓内容。


## Git 接入状态

接入项目前先判断 Git 状态：

| 状态 | 处理 |
|---|---|
| 已有 `.git` | 使用现有 Git，不重新初始化 |
| 没有 `.git` | 不自动 `git init`，先问用户是否需要 Git 管理 |
| 父目录有 `.git` | 判断是否 monorepo；不要在父目录误提交子仓内容 |
| 子仓各自有 `.git` | 每个子仓分别检查、分别提交 |
| 不确定 | 停下来报告目录结构和 Git 发现结果 |

无 Git 项目接入规则：

- 可以接入 `CLAUDE.md`、`AGENTS.md`、`.ai-rules/`、`skills/`。
- 不自动初始化 Git。
- 不创建 remote。
- 不 push。
- 如用户要求启用 Git，先说明将执行的命令和影响，再等待确认。

新项目例外：

- 如果当前目录是空项目或新项目，且用户已经确认项目计划并明确说“执行”，可以在当前项目目录初始化 Git。
- 初始化 Git 之后仍然不创建 remote、不 push、不自动提交，除非用户明确要求。
- 老项目、旧代码目录、状态不明目录不适用此例外。

已有 Git 项目接入规则：

- 接入前先执行 `git status --short`。
- 有未提交改动时，先报告，不覆盖、不清理、不 stash。
- 新增规则文件后，提交仍需用户明确要求。
- 如果已有 AI 规则，生成 `.proposed`，不直接覆盖。

## 多仓工作区

如果父目录下面有多个独立 Git 子仓：

```text
workspace/
├── backend/    # 独立 git 仓库
└── frontend/   # 独立 git 仓库
```

必须遵守：

- 父目录只做协调，不执行 `git add` / `git commit` / `git push`。
- 后端改动只在后端仓库提交。
- 前端改动只在前端仓库提交。
- 跨仓任务分别检查每个子仓的 `git status`。
- 跨仓任务分别提交；不要把多个仓库当成一个仓库提交。

## 分支命名

默认主分支：main。

如果老项目已经使用 master、dev、develop 或其它主分支命名，尊重现有分支，不自动改名。

推荐工作分支：

```text
feature/<short-name>
fix/<short-name>
chore/<short-name>
docs/<short-name>
```

全栈任务前后端建议使用同名分支，便于关联。

## 提交信息

使用简洁 Conventional Commits：

```text
feat(scope): add workflow task api
fix(scope): repair empty state rendering
docs(scope): update contract notes
refactor(scope): split media gateway service
test(scope): add api smoke coverage
chore(scope): update local scripts
```

常用 type：

- `feat`：新功能
- `fix`：缺陷修复
- `docs`：文档
- `refactor`：重构，不改变行为
- `test`：测试
- `chore`：杂项维护
- `build`：构建相关
- `ci`：CI 相关
- `perf`：性能优化
- `style`：格式，不改变行为
- `revert`：回滚


## 本地备份规范

在无 Git、Git 状态不干净、或需要替换已有规则文件时，优先使用本地备份或 `.proposed` 文件保护现场。

推荐策略：

- 默认生成 `.proposed`，不覆盖原文件。
- 用户确认替换前，先备份原文件。
- 备份命名建议：`<filename>.bak-YYYYMMDD-HHMMSS`。
- 备份只针对将被替换的规则文件，不备份整个项目。
- 不备份密钥、依赖目录、构建产物、临时缓存。

可备份的文件类型：

- `CLAUDE.md`
- `AGENTS.md`
- `.ai-rules/*.md`
- `skills/*/SKILL.md`
- `docs/` 中确认要替换的模板文档

禁止：

- 未经确认直接覆盖已有规则。
- 为了备份复制整个仓库。
- 把备份文件提交到 Git，除非用户明确要求。
- 备份或输出密钥文件。

## 提交前检查

提交前至少确认：

1. 当前所在仓库正确。
2. `git status` 清楚。
3. `git diff` 只包含本次任务内容。
4. 已运行最小相关验证，或已说明无法验证原因。
5. 没有密钥和生产配置。
6. 没有用户未授权的删除、覆盖、格式化大改。
7. commit message 能说明本次改动。

## MR/PR 顺序

跨前后端任务建议：

1. 后端 MR/PR 先建。
2. 前端 MR/PR 后建。
3. 两个 MR/PR 互相引用。
4. 后端契约先稳定，前端再适配。

## 停止条件

遇到以下情况必须停下来问用户：

- 用户没有明确要求提交。
- 有不属于本次任务的改动。
- 发现密钥、生产配置或敏感数据。
- 需要 `git push`。
- 需要创建 MR/PR。
- 需要重写历史、rebase、reset、force push。
- 当前目录可能是父目录而不是具体子仓。


