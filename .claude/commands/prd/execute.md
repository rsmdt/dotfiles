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
  - WebSearch
  - WebFetch
  - Task
  - TodoWrite
argument-hint: <PRD file path or feature ID>
---

# Execute PRD Implementation

Execute the Product Requirement Document (PRD) for: **$ARGUMENTS**

## Overview
Orchestrates PRD implementation through specialized sub-agents, ensuring systematic execution, proper validation, and clear progress tracking.

## Execution Flow

### Phase 1: Initialization
1. **Locate PRD**: Find the PRD using the provided argument
   - If ID (e.g., "001"): Search `docs/features/001-*.md`
   - If path: Use directly
   - If name: Search `docs/features/` for matching title

2. **Prepare Context**: 
   - Read CLAUDE.md files (global and project)
   - Read the entire PRD
   - Use `the-project-manager` subagent to analyze implementation checklist

### Phase 2: Implementation Loop
Execute implementation phases as identified by the task manager:

1. **Task Planning**: 
   Use `the-project-manager` to:
   - Identify next tasks to execute
   - Determine which tasks can run in parallel
   - Mark identified tasks as `[~]` in PRD before execution

2. **Parallel Implementation**:
   For each group of independent tasks, spawn multiple `the-developer` agents simultaneously, each with:
   - Specific task assignment
   - Relevant PRD context (patterns, specs, examples)
   - Clear scope boundaries
   
   While implementers run, provide progress updates in chat:
   ```
   🔄 Starting parallel execution:
   - Task 1: Component structure
   - Task 2: Data fetching logic
   - Task 3: Error handling
   ```

3. **Task Completion**:
   As implementers return results:
   - Task manager updates PRD: `[~]` → `[x]` for success
   - Task manager updates PRD: `[~]` → `[BLOCKED: reason]` for blockers
   - Main orchestrator reports status in chat

4. **Validation**:
   After all implementers in phase complete, use `the-tester` agent to:
   - Run all validation commands
   - Interpret results
   - Suggest fixes for issues

5. **Progress Update**:
   Task manager provides comprehensive status and determines next phase

Continue loop until all tasks complete or blockers are encountered.

### Phase 3: Completion Handling

#### If All Tasks Complete:
- Task manager updates PRD with completion timestamp
- Provide final success report

#### If Tasks Remain Incomplete:
Enter interactive completion mode:
1. Task manager generates comprehensive status report
2. Present blockers and options to user
3. Based on guidance, continue implementation
4. Repeat until resolution

## Orchestration Guidelines

### Parallel Execution
When task manager identifies independent tasks:
- Launch multiple implementers in single Task invocation
- Each implementer gets focused context
- Consolidate results before validation
- Update all task states together

### Error Handling
When implementers report blockers:
- Collect all blocker information
- Run validator to check current state
- Present consolidated issues to user
- Await guidance before proceeding

### Progress Tracking
Throughout execution:
- Task manager maintains source of truth in PRD
- Regular status updates in chat
- Clear visibility of completed/blocked/remaining tasks

## Example Execution Flow

```
1. Task Manager: "Phase 1 has 3 independent tasks ready"
   - Updates PRD: marks all 3 tasks as [~]
   
2. Main: Spawns 3 implementers for parallel execution
   - Reports in chat: "🔄 Starting 3 parallel tasks..."
   
3. Implementers complete:
   - Implementer 1: "TASK_COMPLETE: Created component structure"
   - Implementer 2: "TASK_COMPLETE: Added data fetching logic"
   - Implementer 3: "TASK_BLOCKED: Missing API endpoint specification"
   
4. Task Manager: Updates PRD based on results
   - Task 1: [~] → [x]
   - Task 2: [~] → [x]  
   - Task 3: [~] → [BLOCKED: Missing API endpoint]
   
5. Validator: Runs validation on completed work
   - "VALIDATION_FAILED: 2 linting errors in component file"
   
6. Main: Reports consolidated status
   - "✅ 2/3 tasks complete, 1 blocked, validation errors to fix"
   
7. Present options to user for resolution
```

## Key Principles

- **Separation of Concerns**: Each agent has a focused role
- **Parallel When Possible**: Maximize efficiency within phases
- **Clear State Tracking**: PRD is single source of truth
- **Fail Fast**: Report blockers immediately
- **Interactive Resolution**: Work with user to resolve issues
- **Quality Validation**: Never skip validation steps

## Resuming Partial Implementation

If returning to incomplete PRD:
1. Task manager reads current state
2. Validator checks code state
3. Continue from last incomplete phase
4. Maintain previous context and decisions

Begin by locating the PRD and initializing the implementation process.
