---
name: commit
description: Analyze staged changes and create a detailed git commit message in English
metadata:
  author: kazukit
  version: 0.1.0
---

## Commit Rules

### Commit Format

Use Conventional Commits format:

```
<type>[optional scope]: <description>

[optional body]
```

**Types:**

- `feat`: add a new feature
- `fix`: fix a bug
- `docs`: documentation only changes
- `style`: formatting, white-space, missing semi-colons (no code change)
- `refactor`: code change that neither fixes a bug nor adds a feature
- `perf`: code change that improves performance
- `test`: adding or correcting tests
- `chore`: build process, tools, dependencies

**Scope (optional):**

Functional area or component affected. Use categories rather than specific file names.
Examples: `config`, `docs`, `api`, `ui`, `cli`, `deps`, `build`, `test`

**Body (optional):**

Use bullet points to explain **what** and **why**:

- One point per line
- Keep concise

**Footer (required):**

Always include the Co-Authored-By trailer with the model name:

```
Co-Authored-By: Claude <model> <noreply@anthropic.com>
```

### Message Guidelines

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Keep subject line under 100 characters
- Use body to explain **what and why**, not how
- Make atomic commits (one logical change per commit)
- Always add Co-Authored-By footer

## Workflow

1. **Check current state:**
   - Run `git status` to see staged and unstaged changes
   - Run `git diff --cached` to review staged changes
   - Run `git diff` to check unstaged changes
   - Run `git log --oneline -5` to match existing commit style
   - If no changes exist, inform user and exit

2. **Analyze atomicity:**
   - Check if staged changes represent a single logical change
   - If changes include multiple unrelated modifications (e.g., different features, different files with different purposes), they should be split into separate commits
   - Group related changes together (e.g., code + tests, config + docs)

3. **Determine commit strategy:**
   - **Atomic (single commit):** All changes relate to one logical purpose
   - **Non-atomic (multiple commits):** Changes include separate logical modifications
     - Reset staging: `git reset HEAD`
     - Commit each logical group separately using `git add <files>` then commit

4. **Execute commit(s):**
   - Use HEREDOC format to ensure proper multi-line formatting:
     ```bash
     git commit -m "$(cat <<'EOF'
     <commit message here>
     EOF
     )"
     ```
   - For multiple commits, repeat for each logical group

5. **Verify:**
   - Run `git status` to confirm successful commit(s)
