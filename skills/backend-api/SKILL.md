---
name: backend-api
description: 设计和实现后端 API。用于 REST/OpenAPI、DTO、错误响应、service/repository 分层、health/ready、CORS、配置和 API smoke。
---

# Backend API

## 目标

设计稳定、可测试、难误用的后端接口。契约先行，边界清楚，错误一致，长任务异步，外部输入只在边界信任前校验。

## 适用场景

- 新增或修改 API endpoint。
- 定义 DTO、OpenAPI、错误响应、分页、筛选。
- 调整 service/repository 分层。
- 增加 health、ready、CORS、配置管理。

## 不适用场景

- 纯 UI 修改。
- 纯数据库迁移但不改 API。
- 外部媒体或 AI gateway 的真实接入细节。

## 最小上下文

1. route/controller。
2. DTO/schema。
3. service/repository。
4. API contract/OpenAPI。
5. 相关测试和启动命令。

## 工作流

1. 先写或确认契约，再实现代码。
2. API 层只处理协议、参数、响应、鉴权和边界校验。
3. service 层做业务编排，repository 层做持久化。
4. 输入 DTO 和输出 DTO 分离；不要把 ORM/internal model 直接暴露给前端。
5. 错误响应使用统一 envelope，500 不泄露堆栈。
6. 列表接口默认考虑分页、排序、筛选。
7. 第三方响应当作不可信输入，必须校验后再使用。
8. request handler 不执行长任务，改为任务队列、worker 或明确 mock。
9. health 和 ready 分开：health 表示进程活着，ready 表示依赖可用。
10. 改 API 时同步 contract、测试和 smoke。

## 推荐响应约定

```json
{
  "data": {},
  "error": null
}
```

错误：

```json
{
  "data": null,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "参数不合法",
    "details": {}
  }
}
```

## 常见合理化借口

| 借口 | 实际处理 |
|---|---|
| 接口先写出来，文档以后补 | 契约就是并行协作基础，先补最小契约 |
| handler 里直接写业务更快 | 分层，避免不可测和不可复用 |
| 列表现在数据少不用分页 | API 一旦公开，行为会被依赖，先设计扩展点 |
| 第三方返回我们信得过 | 外部响应永远要校验 |

## 红旗

- 不同 endpoint 返回不同错误形状。
- API URL 使用动词，例如 `/createTask`。
- handler 里直接访问数据库和外部服务。
- 长任务同步阻塞请求。
- DTO 缺少校验。
- CORS 使用全开放但没有说明边界。
- 前端依赖了未写入契约的字段。

## 验证清单

- [ ] 每个 endpoint 有输入/输出 DTO。
- [ ] 错误格式一致。
- [ ] 边界输入已校验。
- [ ] 列表接口有分页或明确无需分页的理由。
- [ ] API contract/OpenAPI 已同步。
- [ ] 单测、lint/typecheck、API smoke 已执行或说明原因。

## 输出要求

说明 endpoint、DTO、错误语义、契约更新、兼容性、验证命令、smoke 结果和未验证风险。
## 停止条件

- 需要新增或改变认证、权限、租户隔离但用户未确认。
- 需要修改公开 API 契约且没有同步前端或调用方影响。
- 需要连接真实数据库、Redis、队列或外部服务但用户未确认。
- 错误响应、DTO 或迁移方案不清，继续会造成兼容性风险。
## 强制执行规则

- 一旦本 skill 被任务路由命中，必须按本文件工作流执行；不得只把它当作参考建议。
- 必须先读取本 skill 的最小上下文，再改文件、跑命令或给结论。
- 必须遵守项目级红线：不得写入或修改用户全局 Claude / Codex 配置、全局 rules、全局 skills、全局 hooks、全局 MCP。
- 必须优先使用项目 `.ai-spec/skills/`；读取用户本地 skill 前，必须说明项目 skill 缺口和本地 skill 名称。
- 遇到停止条件必须停下来报告，不得绕过、弱化或自行假设用户已确认。
- 涉及真实外部服务、生产数据、权限、安全、DB、文件删除、Git push、全局配置时，必须先取得用户确认。
- 必须保持代码和输出模块化；不得把职责、计划、解释、验证和风险混在一起。
- 最终输出必须说明：使用了哪个 skill、改了什么、验证了什么、未验证什么、是否触发停止条件。


