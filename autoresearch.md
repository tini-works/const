# Autoresearch: Vertical Self-Evidence

## Config
- **Benchmark**: `bash autoresearch-eval.sh`
- **Target metric**: `self_evidence_score` (higher is better), `prescriptiveness` (lower is better)
- **Scope**: CONST.md, companion/skills/const-companion/SKILL.md
- **Branch**: `autoresearch/vertical-self-evidence`
- **Started**: 2026-03-19

## Rules
1. One change per experiment
2. Run benchmark after every change
3. Keep if metric improves, discard if it regresses
4. Log every run to autoresearch.jsonl
5. Commit kept changes with `Result:` trailer
