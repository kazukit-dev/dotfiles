# Agents

## Task Decomposition and Subagent Delegation

When you receive a request, follow these steps.

### 1. Decompose the request

Break the request into independently executable subtasks.

- Identify the goal and enumerate the work required
- Map dependencies between subtasks
- Subtasks with no dependencies on each other are candidates for parallel delegation

### 2. Delegate to subagents

Delegate subtasks that can run independently. Issue independent subagent calls in a single message so they run in parallel.

**Delegate:**

- File exploration and code search
- Independent file reads and analysis
- Multiple changes that do not depend on each other
- Review and verification tasks

**Keep in the main context:**

- Decisions that depend on a previous step's result
- Interactions that require user input
- Final integration and synthesis of results

### 3. Integrate and report

Collect subagent results, synthesize them, and report back concisely.
