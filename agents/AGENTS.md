# Agents

## Subagents

- Delegate work that can run independently, such as broad code searches, independent changes, and review or verification, to subagents. Issue independent calls in a single message so they run in parallel.
- Keep in the main context the decisions that depend on earlier results, interactions with the user, and the integration of results.

## Code

When working on code (implementing, changing, fixing bugs, refactoring, writing tests, or reviewing), load the `kazuki-mode` skill first and follow it.
