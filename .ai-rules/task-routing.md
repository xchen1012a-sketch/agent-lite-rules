# 任务路由

## 基本流程

1. 先判断任务等级。
2. 再选择 0-2 个最相关 skills。
3. 读取最小必要上下文。
4. 执行任务。
5. 用证据完成验证。

## 分级

- L0：问答、解释、状态查询，不改文件。
- L1：单文件或小范围修改，不影响 API、数据库、权限、进程、部署。
- L2：一个模块内修改，需要测试验证。
- L3：涉及 API/DTO、数据库、权限、安全、进程、外部服务、前后端联调。
- L4：项目初始化、架构调整、阶段切换、跨仓协作、规则接入。

## Skill 优先级

- 默认 project-first：先用项目 .ai-spec/skills/。
- 项目 skill 不足时，可读取用户本地 skill 补充，但必须先说明缺口。
- 用户可指定 project-only 或 local-first。
- 本地 skill 不能覆盖项目红线、契约、任务等级和验证要求。
- 任何模式都不允许自动修改用户全局 Claude / Codex 配置。

## 模块化要求

- 写代码必须保持模块化：职责单一、边界清楚、入口轻、逻辑可测。
- 写报告必须保持模块化：结论、变更、验证、风险、下一步分开写。
- 多模块、多仓、多阶段任务必须按模块/仓库/阶段分段输出。
- 如果任务会破坏现有模块边界，必须先报告并等待用户确认。
- 涉及新增模块、多文件实现、重构或输出结构复杂时，读取 `.ai-rules/modularity-output.md`。

## Skill 路由

### 领域 skill

- 项目初始化、阶段切换、架构变化：`project-planning`
- Web 前端、UI、API client：`frontend-web`
- REST/OpenAPI、DTO、service/repository：`backend-api`
- 数据库设计、迁移、索引：`database`
- Agent、Skill、工作流节点：`ai-workflow`
- ComfyUI、TTS、FFmpeg、素材、导出：`media-pipeline`
- 测试、验证、回归：`testing-verification`
- 本地启动、端口、健康检查：`deployment-local`

### 横向质量 skill

- 多文件变更、功能开发、重构、阶段任务：`incremental-implementation`
- 测试失败、构建失败、运行异常、进程闪退：`debugging-recovery`
- 用户要求 review、合并前检查、AI 代码把关：`code-review-quality`
- 认证、权限、输入、文件、路径、密钥、外部服务：`security-hardening`
- ADR、API 文档、验收证据、日志、指标、追踪：`documentation-observability`

## 组合建议

- L0：通常不读 skill。
- L1：最多 1 个领域 skill。
- L2：1 个领域 skill，可加 `testing-verification` 或 `incremental-implementation`。
- L3：1 个领域 skill + 1 个横向质量 skill。
- L4：`project-planning` + 一个最关键的领域或横向质量 skill。

## 不要过度升级

- 不因不确定就直接提升到 L4。
- 不把问答任务当成开发任务。
- 不把小改动升级成项目重构。
- 不为了使用 skill 而读取无关 skill。
- 不一次读取超过 2 个 skill，除非用户明确要求全面审计。

