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

## Code style

Follow the rules below when writing new code or editing existing code.
When a rule conflicts with the existing style of the file being edited or of the modules it directly depends on, follow the existing style instead.
Do not rewrite existing code just to conform to these rules unless refactoring was explicitly requested.

### Comment

- As a rule, do not write comments. Aim for code whose intent is conveyed by the code and its naming.
- Write comments only for what cannot be read from the code:
  - Why this implementation was chosen (why the obvious alternatives were rejected)
  - Constraints of external specs or APIs, workarounds for known bugs and their references
  - Why code that looks unnecessary or unnatural is in fact required
  - A summary of dense passages whose intent is unreadable, such as regular expressions or bit manipulation
- Do not write:
  - A play-by-play of the processing (e.g. "fetch the user information")
  - Change history or diff explanations (e.g. "fixed this", "previously it was ...")
    → These belong in the commit message
  - Restatements of a type or an argument name
- Write comments in Japanese.
- JSDoc on public APIs is an accepted exception.

### Test

- Tests verify behavior. Exercise the target only through its public interface, and do not assert on internal steps or intermediate state.
  - Rule of thumb: a test that breaks when you refactor without changing externally observable behavior is testing internal logic.
- Do not expose a function, type, or property solely for testing.
  If that seems necessary, treat it as a design problem: do not change the structure on your own, propose a review instead.
- Use mocks only for dependencies you cannot control, such as external services, time, randomness, and the file system.
  Do not mock modules we wrote ourselves.
  Do not assert on which function was called in which order.
- Verify one behavior per test, so that the failure message makes clear what broke.
- Do not delete or skip existing tests, and do not weaken assertions to make them pass.
  When a test fails, decide whether the implementation or the test's premise is wrong, and report it with the reasoning.
- Do not depend on time, randomness, or execution order. Inject fixed values when needed.
- The comment rules apply to test code as well. Express what is being verified in the test name.
- Write test names in Japanese.

### JavaScript / TypeScript

- As a rule, do not use class syntax. Compose code from functions and plain objects.
- Do not hide state: take it as an argument and return a new value, as a pure function. Avoid destructive updates (`push`, `splice`, property reassignment, and the like); return new objects and arrays using spread syntax.
- Push side effects (I/O, DOM manipulation, logging) to the caller's boundary, and keep the logic itself pure.
- Build logic by composing small functions. When encapsulation is needed, use closures or module scope rather than classes.
- Exceptions: it is fine to use classes for `Error` subclasses, Web Components, and places where an external library or framework requires them.
