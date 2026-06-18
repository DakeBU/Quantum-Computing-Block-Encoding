# ABEIS 报告与记忆入口说明

生成时间：`2026-06-18 18:52:53`

任务：`QBE-AUTO-002`

对应 run：`runs/20260617-060327-QBE-AUTO-002-cycle01`

这个文件只解决一个问题：**人类和 agent 到底应该先读哪个文件，哪些文件只是原始日志，不应该作为决策入口？**

## 首选阅读顺序

1. `HUMAN_STATUS.md`：总入口，只看当前任务是否完成、剩几个 `sorry`、下一步是什么。
2. `paper-notes/GHL2025/markdown/unresolved-failures.zh.md`：给人看的 GHL 未完成/失败原因地图，按原文位置解释。
3. `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md`：Fig. 4 视觉审计，说明完整线路和七门 backend 子组件的区别。
4. `runs/<latest>/memory_digest.md` 与 `runs/<latest>/todo.md`：给 upper/middle agent 的短记忆包。
5. `research-wiki/retrieval-index/QBE-AUTO-002.json`：给工具和 agent 检索用的压缩 JSON。
6. `proof-attempts/` 与 `verifier-feedback/`：只有在调查某个具体 leaf 为什么失败时才打开。

## 不再作为首选入口的文件

- `paper-notes/project-paper/cycle-updates/*`：这是技术报告素材，不是 proof-control 入口。
- `runs/logs/*.log`：这是原始运行日志，只用来查 crash、quota、build gate。
- `paper-notes/GHL2025/markdown/cycle-summaries/*`：这是 6h 收尾中文审计归档；最新状态优先看 `HUMAN_STATUS.md` 和失败地图。
- `appendix/generated_cycle_status.*`：这是给技术报告 appendix 的生成状态，不应该让 lower agent 从这里反推 Lean 任务。

## 6h 运行后的报告节奏

- 每个 inner proof-search cycle：只刷新 compact memory，避免大量中文总结和文章 update 淹没检索。
- 每个 6h active-time batch 结束：默认运行 upper panel 与 middle panel，然后统一生成中文总结、memory refresh、技术报告 update、human status、Fig. 4 审计和失败地图。
- 如果只是短调试，可以显式用 `sleep-run --summary-each-cycle` 打开每轮中文总结。

## Agent panel 节奏

- inner cycle 默认不跑 panel：lower proof search 优先，避免把 token 花在重复讨论上。
- final audit 默认跑 upper panel：source/visual、proof-DAG、process/memory 三个 specialist 先给判断，再由 upper director 统一决策。
- final audit 默认跑 middle panel：source-correspondence、memory/retrieval、report/export 三个 specialist 先整理材料，再由 middle coordinator 写下一轮 lower packet。
- 如果 6h 中途连续遇到 source 图像误读、stale leaf、memory drift 或报告混乱，可以临时设置 `QBE_UPPER_PANEL_INNER=1` 或 `QBE_MIDDLE_PANEL_INNER=1`。

## 当前任务的决策规则

- 当前 GHL target 是 one-term Robin theorem 的 Fig. 4 / Eq. ROBIN clarified / block-entry bridge。
- 完整 Fig. 4 transcript 与七门 backend 子组件必须分开说。
- 不允许把外部 oracle contract、`H_W` state-preparation、`O_f`、QSVT、LCU 写成已经 Lean 证明完成。
- 不允许让 lower agent 重试 raw `Coeff` constructor equality；应优先证明 `Coeff.evalWith` 后的 semantic entry bridge。

## 文件夹角色

| 文件夹 | 角色 |
| --- | --- |
| `QuantumBlockEncoding/` | 唯一正式 Lean 证明源。 |
| `research-wiki/retrieval-index/` | 压缩检索层，减少反复读长日志。 |
| `research-wiki/paper-contributions/GHL2025/` | GHL 本文贡献和 source map。 |
| `research-wiki/technical-lemmas/` | 前人 lemma、经典 primitive、contract-only 结果。 |
| `proof-blueprints/` | proof-DAG 和 active leaf 排队。 |
| `verifier-feedback/` | typed failure/reward feedback。 |
| `proof-attempts/` | lower agent 成功/失败路线的人类可查档案。 |
| `paper-notes/GHL2025/markdown/` | 给人类读的 GHL 对照说明。 |
| `paper-notes/project-paper/` | 技术报告素材，不是日常 proof 控制入口。 |

