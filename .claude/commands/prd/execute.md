---
description: Execute a Product Requirement Document to implement the specified feature
allowed-tools:
  - LS
  - Glob
  - Grep
  - Read
  - Write
  - MultiEdit
  - Edit
  - Bash
  - TodoWrite
  - WebSearch
  - WebFetch
  - Task
argument-hint: <PRD file path or feature ID>
---

# Execute PRD Implementation

Execute the Product Requirement Document (PRD) for: **$ARGUMENTS**

## ⚠️ CRITICAL EXECUTION REQUIREMENTS

1. **READ ALL CONTEXT FILES**: The PRD contains a YAML list of files that MUST be read
2. **UPDATE TASKS IN REAL-TIME**: Edit the PRD file to update checkboxes as you work
3. **NO DEEP ANALYSIS NEEDED**: The Create command already did the analysis - just read and implement
4. **CHECK FILES FREELY**: Use LS to verify directories and files as needed

## Execution Steps

### 1. Locate PRD
Find the PRD using the provided argument:
- If ID (e.g., "001"): Search `docs/features/001-*.md`
- If path: Use directly
- If name: Search `docs/features/` for matching title

**If PRD not found**: List available PRDs in `docs/features/` and ask for clarification.
**If multiple matches**: Show all matches and ask which to execute.

### 2. Comprehensive Preparation
Read these resources in order:
1. **CLAUDE.md files** - Global (`~/.claude/CLAUDE.md`) and project (`./CLAUDE.md`)
2. **The entire PRD** - Every section contains critical details

**Required Context Reading**:
The PRD contains a YAML list of files in the "Context and Scope" section. Read ALL listed files:
```yaml
- file: path/to/file.ts
  why: [Reason provided]
- doc: docs/patterns/pattern.md
  why: [Pattern to follow]
```

**Important**: The Create command already analyzed these files. Reading them gives you the same context without re-analysis.

### 3. Execute Implementation
Work through the PRD's Implementation Checklist:

**Real-Time Task Updates**:
1. **Before starting ANY work**: Update PRD file, change [ ] to [~]
2. **Track granular progress**: 
   - Starting TDD? Mark test task as [~]
   - Writing test file? Keep test task as [~]
   - Test passes? Mark test task as [x]
   - Starting implementation? Mark implementation task as [~]
3. **After completing a task**: Update PRD file, change [~] to [x]
4. **If discovering new subtasks**: Add them to the checklist with marker:
   ```markdown
   - [ ] Original task
     - [ ] Original subtask
     - [ ] [ADDED] New discovered subtask  
   ```
5. **Match activities to tasks**: Every file creation, test write, or code change should correspond to a tracked task

**Implementation Flow**:
- Use Edit/MultiEdit to update task checkboxes IN THE PRD FILE
- Follow TDD: Write tests first (from PRD test specs)
- Complete each task fully before moving to the next
- Run validation after each task
- Fix all issues before marking [x]

**Activity-to-Task Attribution**:
Every action must map to a specific task in the PRD:
1. Before ANY file creation or code change - find the corresponding task
2. Mark that task [~] BEFORE starting work
3. Keep task as [~] while work is in progress
4. Only mark [x] when the task is fully complete and validated
5. If an activity doesn't map to an existing task, add it as [ADDED]
6. **NEVER skip tasks** - If blocked, mark as:
   - [ ] Task name [BLOCKED: reason]
   Then stop and ask for user guidance
7. Examples:
   - Creating a test file? Find/mark the test task [~]
   - Writing component code? Find/mark the component task [~]
   - Adding error handling? Find/mark the error handling task [~]

**In-Chat Progress Updates**:
Provide regular status updates in chat:
- When starting a major task: "🔄 Starting: [Task name]"
- When completing a task: "✅ Completed: [Task name]"
- Every 3-5 subtasks: Brief progress summary
- When blocked: "⚠️ Blocked on [Task]: [Reason]"

Example progress message:
```
📊 Progress Update:
- ✅ Component structure (completed)
- 🔄 Data fetching logic (in progress - adding error handling)
- ⏳ Tests (up next)
Overall: 3/7 tasks complete
```

### 4. Validate Efficiently
Run validation commands specified in the PRD. Consider this order for faster feedback:
1. Linting (fastest)
2. Type checking 
3. Tests
4. Build (slowest)

Report validation results in chat after each step.

### 5. Handle Errors
Common scenarios and solutions:
- **Test failures**: Read error, check PRD patterns, fix and re-run
- **Type errors**: Verify imports and interfaces match PRD examples
- **Lint issues**: Use auto-fix options when safe
- **Missing dependencies**: Check if functionality exists before adding
- **Conflicting requirements**: Stop and ask for clarification

**When to Stop and Report**:
- After multiple failed attempts to fix the same error
- When encountering architectural decisions not covered in PRD
- If implementation would deviate significantly from PRD
- When missing critical context despite PRD information
- If blocked by external dependencies or permissions

Always report blockers in chat immediately rather than struggling silently.

**Handling Blocked Tasks**:
When you cannot complete a task:
1. Mark it as: `[ ] Task name [BLOCKED: specific reason]`
2. Stop immediately and report to user
3. Do NOT mark as "skipped" or "future work"
4. Do NOT continue to other tasks unless user approves
5. Ask for specific guidance on how to proceed

**Rollback Strategy**: If major issues arise:
- Document what was attempted
- Revert problematic changes
- Ask for guidance with specific error details

### 6. Complete and Verify

#### 6.1 Check Implementation Status
Review the PRD implementation checklist to categorize all tasks:
- **Completed [x]**: Tasks fully implemented and validated
- **In Progress [~]**: Tasks started but not finished
- **Not Started [ ]**: Tasks not yet attempted

#### 6.2 Handle Incomplete Implementation
If ANY tasks are not marked [x], enter **Interactive Completion Mode**:

**Status Report** (provide in chat):
```
## Implementation Status Report

### ✅ Completed Tasks (X/total)
- [List each completed task with brief outcome]

### 🔄 In Progress Tasks (X/total)
- [Task name]: [What was done, what remains, why stopped]

### ⏳ Not Started Tasks (X/total)
- [Task name]: [Why not attempted - missing context, blocked by X, needs clarification]

### 🚧 Blockers and Issues
- [List any errors, missing information, or decisions needed]

### Next Steps
Would you like me to:
1. Continue with in-progress tasks?
2. Attempt the not-started tasks?
3. Debug specific blockers?
4. Something else?

Please provide guidance on how to proceed.
```

**Interactive Loop**:
1. Based on user guidance, continue implementation
2. Update task checkboxes in real-time
3. Provide progress updates in chat during work
4. Repeat status report after each work session
5. Continue until all tasks are [x] or user accepts partial implementation

#### 6.3 Final Completion
Only when ALL tasks are [x]:

**Final PRD Updates** (use Edit on PRD file):
- Add to frontmatter:
  - `implemented_at: [current timestamp]`

**Completion Report** (provide in chat):
```
## Implementation Status: [Complete ✓ | Partial ⚠️]

### Task Summary
- Completed: X/Y tasks (X%)
- Blocked: X tasks
- Not attempted: X tasks

### Details
- Timestamp: [timestamp]
- Validation status: [passing/failing/partial]

### Completed Tasks
- [List what was successfully implemented]

### Incomplete Tasks
- [Task name]: [Status - BLOCKED/NOT STARTED] - [Reason]

### Next Steps Required
- [What needs to be done to achieve 100% completion]
- [Why manual intervention is needed]

Note: Implementation is only complete when ALL tasks are marked [x].
```

## Core Principles

- **Read first, execute second** - Understand before coding
- **Never skip validation** - Run after every change
- **Never skip tasks** - Block and ask rather than skip
- **Never guess** - Re-read PRD or ask if unclear
- **Quality over speed** - Correct implementation matters more
- **One task at a time** - Full completion before moving on
- **Interactive completion** - Work with user to resolve blockers
- **Transparent progress** - Always show what's done, in-progress, and blocked
- **100% completion is the goal** - Partial implementation requires user approval

## Resuming Work

If returning to a partially completed PRD:
1. Check which tasks are marked [~] or [x]
2. Run validation to verify current state
3. Continue from the last incomplete task
4. Re-read relevant PRD sections for context

## Task Tracking Example

Example PRD checklist during execution:
```markdown
### Component Implementation
- [~] Create StoryDetail component      # Currently working on this
  - [x] Component structure            # Done
  - [~] Data fetching logic           # Writing this code now
  - [ ] Error handling                # Not started
  
### Tests  
- [x] Unit tests for data hook         # Completed earlier
  - [x] Test data fetching
  - [x] Test error states
- [~] Component tests                  # Currently active
  - [x] Test story rendering
  - [~] Test navigation                # Just started writing this
  - [ ] Test loading states
  
### Documentation
- [ ] Update API documentation         # Not started
- [ ] [ADDED] Add usage examples      # Discovered need during implementation
```

Key points:
- Every activity has a corresponding task marked [~]
- Tasks marked [x] only when fully complete
- Parent tasks stay [~] until all subtasks complete
- New discoveries become [ADDED] tasks

## Example Interactive Completion

When tasks remain incomplete:
```
## Implementation Status Report

### ✅ Completed Tasks (4/7)
- Created story detail route component
- Implemented data fetching hooks
- Added chapter navigation
- Updated routing configuration

### 🔄 In Progress Tasks (1/7)
- **Keyboard navigation**: Arrow key handlers added, but ESC key behavior needs testing with modal conflicts

### ⏳ Not Started Tasks (2/7)
- **Tests**: [BLOCKED: Unsure about test strategy - should I use existing test patterns?]
- **Performance optimizations**: [BLOCKED: Waiting for all functionality completion first]

### 🚧 Blockers and Issues
- ESC key conflicts with existing modal close handlers
- Unclear if sidebar should hide or overlay in full-screen mode

### Next Steps
Would you like me to:
1. Continue with keyboard navigation (debug ESC key conflict)?
2. Implement full-screen with sidebar hidden by default?
3. Skip to performance optimizations?
4. Something else?

Please provide guidance on how to proceed.
```

Begin by locating and thoroughly preparing to execute the PRD.
