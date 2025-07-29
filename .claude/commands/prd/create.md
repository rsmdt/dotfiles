---
description: Create a comprehensive Product Requirement Document from a brief description
allowed-tools:
  - Task
  - TodoWrite
argument-hint: <feature description>
---

# Create PRD Command

## Overview
Creates a comprehensive PRD through sequential sub-agent execution, ensuring proper requirements gathering, thorough research, and structured documentation.

## Process

Execute the following steps sequentially. Each step MUST complete before proceeding to the next.

### Step 1: Gather Requirements

Invoke the requirements gathering sub-agent:

```
Task(
  description="Gather requirements",
  prompt="Use the prd-requirements subagent to analyze this feature request: $ARGUMENTS",
  subagent_type="general-purpose"
)
```

**CRITICAL: STOP and wait for user response to clarification questions.**

Note: Only proceed with defaults if user explicitly says to continue.

### Step 2: Research Implementation

After user provides requirements or confirms to proceed with defaults:

```
Task(
  description="Research patterns",
  prompt="Use the prd-researcher subagent with these requirements: [include user's full requirements and answers to clarification questions]",
  subagent_type="general-purpose"
)
```

If sub-agent returns "NEED_MORE_CONTEXT":
- Address the specific requests by gathering additional information
- Re-invoke the sub-agent with the additional context
- Continue until research is complete

### Step 3: Create Documentation

With research findings complete:

```
Task(
  description="Document patterns",
  prompt="Use the prd-documenter subagent to create pattern and interface documentation based on these research findings: [include key research summary]",
  subagent_type="general-purpose"
)
```

If sub-agent returns "NEED_MORE_CONTEXT":
- Conduct additional research as requested
- Re-invoke with enhanced findings

### Step 4: Finalize PRD

After documentation is created:

```
Task(
  description="Create PRD",
  prompt="Use the prd-finalizer subagent to create the final PRD with:
  - Original feature request: $ARGUMENTS
  - Requirements: [requirements from step 1]
  - Research findings: [summary from step 2]
  - Created documentation: [files created in step 3]",
  subagent_type="general-purpose"
)
```

If sub-agent returns "NEED_MORE_CONTEXT":
- Gather the missing information through research or user clarification
- Re-invoke with complete context
- The PRD MUST follow the template at ~/.claude/templates/prd.md

## Orchestration Notes

- Each step builds on the previous one - pass relevant context forward
- If user says "continue with defaults" at requirements stage, document assumptions
- The sub-agents are defined in ~/.claude/agents/ and handle specific responsibilities
- Monitor for any architecture decisions that need user input between steps

## Handling Feedback Loops

When a sub-agent returns "NEED_MORE_CONTEXT":
1. Identify what specific information is needed
2. Determine the best source:
   - User clarification (for requirements/business logic)
   - Additional research (for technical details)
   - Previous sub-agent re-run (for missing context)
3. Gather the information and re-invoke the sub-agent
4. Continue until the sub-agent completes successfully

This ensures comprehensive PRD creation even when initial context is incomplete.

## Final Output

The process will result in:
1. Comprehensive PRD in docs/features/
2. Pattern documentation in docs/patterns/
3. Interface specifications in docs/interfaces/
4. Confidence assessment for implementation success