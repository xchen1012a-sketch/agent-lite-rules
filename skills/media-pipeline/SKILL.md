---
name: media-pipeline
description: 管理媒体处理管线。用于图片、音频、视频、字幕、FFmpeg、ComfyUI、TTS、素材元数据、导出 manifest 和 mock/真实 gateway 边界。
---

# Media Pipeline

## 目标

让媒体任务可控、可复现、可追踪。所有外部媒体服务先通过 mock gateway 定义边界，再接真实服务；所有文件路径和命令参数必须结构化校验。

## 适用场景

- 图片、音频、视频、字幕生成或处理。
- FFmpeg 转码、合成、导出。
- ComfyUI、TTS、外部媒体服务 gateway。
- 素材库、manifest、中间产物管理。

## 不适用场景

- 普通 CRUD。
- 不涉及媒体文件或外部服务的 UI。

## 最小上下文

1. 输入/输出路径规则。
2. 文件存储目录和白名单。
3. gateway 或 mock gateway。
4. 任务状态和 manifest 格式。
5. 相关测试。

## 工作流

1. 明确媒体资产类型：image、audio、video、subtitle、manifest。
2. 拆分原始资产、中间产物、最终产物和元数据。
3. 所有路径通过工作区或白名单解析，禁止 `..` 逃逸。
4. FFmpeg 参数使用数组/结构化对象，不拼接 shell 字符串。
5. 先做 mock gateway：输入、输出、错误码、超时、重试。
6. 接真实 ComfyUI/TTS/FFmpeg 前暂停确认。
7. LLM 生成的内容只能作为候选参数，必须校验后使用。
8. 导出 manifest，记录文件、hash、格式、尺寸/时长、来源和任务 ID。
9. 删除、覆盖、批量清理媒体文件前暂停确认。

## manifest 示例

```json
{
  "taskId": "task_001",
  "assets": [
    { "role": "output", "path": "outputs/video.mp4", "type": "video", "durationMs": 12000 }
  ]
}
```

## 模块边界

- `assets/`、`uploads/` 保存原始输入；不得覆盖用户源文件。
- `workdir/`、`tmp/` 保存中间产物；必须有生命周期和清理策略。
- `outputs/`、`exports/` 只放最终产物；文件名来自任务 ID、资产 ID 或已确认命名规则。
- `manifests/` 记录资产、hash、格式、尺寸/时长、来源和任务 ID；不得只靠目录结构推断状态。
- `gateways/` 封装 ComfyUI、TTS、对象存储等外部服务；mock 和真实实现必须共享接口。
- `adapters/`、`ffmpeg/` 只做参数校验和命令构造；不得拼接 shell 字符串。
- `jobs/`、`workers/` 执行异步任务；不得把长任务放在 API handler。
- `metadata/` 只放可审计元数据；长期业务事实仍归数据库。

## 相邻 Skill 触发

- 需要存储任务、资产、manifest 或状态机时，同时触发 `database`。
- 暴露上传、导出、任务查询 API 时，同时触发 `backend-api`。
- 由 Agent/LLM 生成媒体参数或编排多节点流程时，同时触发 `ai-workflow`。

## 常见合理化借口

| 借口 | 实际处理 |
|---|---|
| FFmpeg 字符串更方便 | 结构化参数，最后由安全适配层转换 |
| 先接真实服务试试 | 先 mock，真实接入要确认 |
| 路径前端传过来就可信 | 后端重新解析和白名单校验 |
| 临时文件不用记录 | 记录生命周期，否则无法清理和复现 |

## 红旗

- shell 命令由字符串拼接。
- 输出路径可由用户任意指定。
- mock 和真实 gateway 行为不一致。
- 没有 manifest。
- 失败只返回“处理失败”。
- 覆盖文件前没有策略。

## 验证清单

- [ ] 路径逃逸测试。
- [ ] mock gateway 单测。
- [ ] FFmpeg/命令参数不拼 shell 字符串的断言。
- [ ] API smoke。
- [ ] manifest 生成测试。
- [ ] 真实外部服务接入已确认或明确未接。

## 输出要求

说明媒体流程、路径白名单、gateway 状态、manifest、真实服务边界、验证结果和未验证风险。
## 停止条件

- 需要接真实 ComfyUI、TTS、FFmpeg、对象存储或付费媒体服务但用户未确认。
- 文件路径、输出目录、格式白名单或资源上限不清。
- 需要执行由 LLM 生成的命令行参数。
- 继续操作可能覆盖、删除或泄露用户素材。
## 强制执行规则

- 一旦本 skill 被任务路由命中，必须按本文件工作流执行；不得只把它当作参考建议。
- 必须先读取本 skill 的最小上下文，再改文件、跑命令或给结论。
- 必须遵守项目级红线：不得写入或修改用户全局 Claude / Codex 配置、全局 rules、全局 skills、全局 hooks、全局 MCP。
- 必须优先使用项目 `.ai-spec/skills/`；读取用户本地 skill 前，必须说明项目 skill 缺口和本地 skill 名称。
- 遇到停止条件必须停下来报告，不得绕过、弱化或自行假设用户已确认。
- 涉及真实外部服务、生产数据、权限、安全、DB、文件删除、Git push、全局配置时，必须先取得用户确认。
- 必须保持代码和输出模块化；不得把职责、计划、解释、验证和风险混在一起。
- 最终输出必须说明：使用了哪个 skill、改了什么、验证了什么、未验证什么、是否触发停止条件。


