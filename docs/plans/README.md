# plans

模板目录里的 `docs/plans` 只提供示例，不记录真实项目状态。

## 真实计划写在哪里

- 单子仓任务：写到该子仓的 `docs/plans/`。
- 跨仓任务：父目录 `docs/plans/` 写总协调计划；各子仓 `docs/plans/` 写各自阶段和验收。
- 规则模板维护：只更新模板示例，不写具体项目事实。

## 使用规则

- 小任务不需要计划。
- `current.md` 是当前阶段入口。
- `project-plan` 只在范围变化、架构变化、阶段变化时维护。
- 阶段完成必须记录验证证据。

## 建议结构

```text
docs/plans/
├── current.md
├── project-plan.md
└── phases/
    ├── FE-01-frontend-mvp-ui.md
    └── BE-01-api-baseline.md
```
