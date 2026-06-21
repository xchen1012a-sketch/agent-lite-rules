# Skills 索引

只读取当前任务命中的 0-2 个 skill。不要默认全量读取所有 skill。

## Skill 优先级

默认优先级是 `project-first`：

1. 先读取项目内 `.ai-spec/skills/*/SKILL.md`。
2. 如果项目 skill 能覆盖任务，不读取用户本地 skill。
3. 如果项目 skill 明显不足，可以读取用户本地 skill 作为补充，但必须先说明缺口和要读取的本地 skill 名称。
4. 用户可以显式切换优先级：`project-first`、`project-only`、`local-first`。

优先级含义：

- `project-first`：默认模式。项目 skill 优先，本地 skill 只做补充。
- `project-only`：只使用项目 skill。适合团队协作、验收、复现和交付。
- `local-first`：用户本地 skill 优先。适合个人增强能力，但不能覆盖项目红线和契约。

无论哪种模式，都不能修改用户全局 Claude / Codex 配置，不能把本地 skill 自动复制进项目，除非用户明确要求。

## 领域 Skills

- `project-planning`：项目初始化、阶段切换、架构变化。
- `frontend-web`：Web 前端、UI、API client。
- `backend-api`：REST/OpenAPI、DTO、service/repository。
- `database`：数据库设计、迁移、索引。
- `ai-workflow`：Agent、Skill、工作流节点。
- `media-pipeline`：ComfyUI、TTS、FFmpeg、素材、导出。
- `testing-verification`：测试、验证、回归。
- `deployment-local`：本地启动、端口、健康检查。

## 横向质量 Skills

- `incremental-implementation`：多文件变更、小步实现、可回滚切片。
- `debugging-recovery`：失败、异常、测试红灯、服务闪退时复现、定位、修复、防回归。
- `code-review-quality`：合并前评审、AI 代码把关、复杂度和测试缺口检查。
- `security-hardening`：认证、权限、输入、文件、路径、密钥、外部服务安全。
- `documentation-observability`：ADR、API 文档、验收证据、结构化日志、指标和追踪。


## 强制调用规则

- 命中 skill 后必须读取对应 `SKILL.md`，不得只看索引就执行。
- 读取 skill 后必须遵守其中的工作流、停止条件和验证方式。
- 项目 skill 优先；用户本地 skill 只能在项目 skill 不足时按需补充。
- 本地 skill 不能覆盖项目红线、契约、任务等级和验证要求。
- 每次最终输出必须说明使用了哪些 skill，以及哪些验证已经完成。
## 读取原则

1. 先根据 `.ai-rules/task-routing.md` 判断任务等级。
2. 再从本索引选择 0-2 个最相关 skill。
3. 领域 skill 解决“做什么类型的事”。
4. 横向质量 skill 解决“怎么把事做稳”。
5. 不因为存在 skill 就读取它；没有命中就不读。
6. 使用本地 skill 时，最终报告要说明它只是补充来源。

