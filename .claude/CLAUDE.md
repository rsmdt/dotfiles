# CLAUDE.md

## 1. Scope Discipline

**Read only what I name. Ask before reading more.**

- Read the files I explicitly name or point to — nothing else.
- Never open extra files to "get context", "understand the project", or "see how things connect".
- If reading more would help, ask in one sentence — "Want me to also read X?" — then wait for my answer.
- Applies to every task. No exceptions for "just checking" or "a quick look".

Two exceptions, and only these two:
- The file you are about to edit — read it first.
- Callers of code I asked you to change — grep for them and read them (see §4).

## 2. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

- State assumptions explicitly before implementing.
- Name what's confusing instead of guessing — never pick silently between readings.
- Present multiple interpretations when they exist; let me choose.
- Push back when a simpler approach exists.
- Surface blockers when you hit them; never route around one silently.

## 3. Simplicity First

**Minimum code that solves the stated problem. Nothing speculative.**

- Match the scale of the solution to the scale of the request.
- Rewrite when 200 lines could be 50.
- No features, abstractions, flexibility, or configurability I didn't ask for.
- No error handling for scenarios that can't happen.

## 4. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

- Grep for all callers before changing a function's signature or behavior.
- Match existing style, even if you'd do it differently.
- Remove imports, variables, and functions that *your* changes orphaned.
- Every change must trace directly to my request — no "improving" adjacent code, comments, or formatting.
- Mention pre-existing dead code; never delete it unless I ask.

## 5. Goal-Driven Execution

**Define the check before you start. Loop until it passes.**

- Turn the task into a verifiable goal first:
  - "Add validation" → "Write tests for invalid inputs, then make them pass"
  - "Fix the bug" → "Write a test that reproduces it, then make it pass"
  - "Refactor X" → "Ensure tests pass before and after"
- Reject weak criteria like "make it work" — name the concrete check instead.
- For multi-step tasks, state the plan as `N. [step] → verify: [check]` lines.
- Never report work complete without running the verification you defined.

## 6. Self-Documenting Code

**Code speaks for itself. A comment is a design failure, not documentation.**

- Names carry the meaning — classes, functions, variables, and types must make intent obvious without commentary.
- Zero comments in code you write: no explanations, section headers, docstrings, or change summaries.
- The urge to comment is a signal: rename or extract until the urge disappears.
- "Condensed" comments are still comments. The target is zero, not fewer.
- Mechanical annotations only when required to work: shebangs, tool directives (`eslint-disable`, `noqa`, `# type: ignore`), language-mandated syntax.
- Before finishing an edit, scan your diff — any added comment line means the edit isn't done.
- Existing comments in touched files stay; never delete unless I ask.

---

@RTK.md
