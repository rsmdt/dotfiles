---
description: Create a comprehensive Product Requirement Document from a brief description
allowed-tools:
  - LS
  - Glob
  - Grep
  - Read
  - Write(docs/**)
  - MultiEdit(docs/**)
  - Edit(docs/**)
  - Bash
  - WebSearch
  - WebFetch
  - Task
  - TodoWrite
argument-hint: <description>
---

# Create PRD Command

## Overview
Creates a comprehensive PRD that enables one-shot implementation by orchestrating specialized subagents and handling critical decision points.

**Feature**: $ARGUMENTS

## Process Flow

Execute phases sequentially, but within each phase, identify opportunities to run multiple agents in parallel for efficiency.

### Phase 1: Requirements Gathering
Use the `the-business-analyst` subagent to analyze the feature request and gather all necessary clarifications. Pass the feature description and let the agent determine what questions need to be asked.

**Parallel Opportunity**: If the feature has multiple distinct aspects that require different domain knowledge or perspectives, consider spawning multiple requirement-gathering subagents to analyze each aspect simultaneously.

**Wait for user response before proceeding to Phase 2.**

Note: Only proceed with defaults if user explicitly says to continue.

### Phase 2: Technical Research
Once requirements are clear, analyze them to identify distinct technical areas that need investigation. For each area, spawn a focused `the-architect` subagent with only the relevant context.

**How to Decompose**: Ask yourself:
- What are the distinct technical challenges in this feature?
- Which parts could be built independently?
- What specialized knowledge areas are needed?
- Where are the natural boundaries in the system?

**Parallel Execution**: Launch all researchers simultaneously in a single Task invocation, each with:
- Specific research area and scope
- Only the requirements relevant to their area
- Clear boundaries to avoid overlap

Consolidate all findings before proceeding to Phase 3.

### Phase 3: Architecture Decisions
After research completes, review the findings for any critical architecture decisions. If significant choices need to be made that impact implementation approach:

Present them in this format:
```
## Architecture Decision Required

### Decision [Number]: [Title]
**Context**: [Why this decision is needed based on research]

**Options**:
1. **Option A**: [Description]
   - Pros: [Benefits]
   - Cons: [Drawbacks]

2. **Option B**: [Description]
   - Pros: [Benefits]
   - Cons: [Drawbacks]

3. ...

**Recommendation**: [Your suggested approach and rationale]
```

Only interrupt for decisions that significantly impact the implementation approach. Document any pending decisions if the user doesn't respond.

### Phase 4: Documentation Creation
Use the `the-technical-writer` subagent to create pattern and interface documentation based on:
- Research findings from Phase 2
- Architecture decisions from Phase 3
- Identified reusable patterns and external integrations

**Parallel Opportunity**: If multiple patterns or interfaces need documentation, spawn multiple `the-technical-writer` agents to create them simultaneously. Consider:
- What distinct patterns were discovered?
- Which external interfaces need specification?
- Are there independent documentation needs?

The agents will create appropriate documentation in docs/patterns/ and docs/interfaces/.

### Phase 5: Validation Check
Before finalizing, check if any critical information is still missing. If there are gaps:

```
## Missing Information for Complete PRD

The following information is needed for a comprehensive PRD:

1. **[Gap Title]**: [What's missing and why it matters]
2. **[Gap Title]**: [What's missing and why it matters]

Would you like me to:
A) Create the PRD with documented assumptions
B) Wait for you to provide this information

[Include what assumptions would be made for option A]
```

### Phase 6: PRD Creation
Use the `the-product-manager` subagent to create the comprehensive PRD. Provide:
- Original feature request
- All requirements and clarifications
- Research findings and technical analysis
- Architecture decisions made
- References to created documentation

The agent will follow the template at ~/.claude/templates/prd.md exactly.

Then, list anything that was not explicitly written to the PRD, but is relevant to guide the implementation process.

### Phase 7: Confidence Assessment
After PRD creation, provide an implementation confidence assessment:

```
## One-Shot Implementation Confidence: [X]%

✅ High Confidence Factors:
- [What enables one-shot success]

⚠️ Risk Factors:
- [What might cause issues]

Missing Information:
- [Gaps that could block implementation]

Recommendation: [Ready for implementation / Needs clarification on X]
```

## Handling subagent Feedback

If any subagent returns "NEED_MORE_CONTEXT":
1. Analyze what specific information is needed
2. Gather it through:
   - User clarification (for business requirements)
   - Additional research (for technical details)
   - Re-running previous agents with more context
3. Re-invoke the subagent with the additional information

## Key Principles
- Execute phases sequentially, but maximize parallelization within each phase
- When a phase could benefit from multiple agents, launch them in a single Task invocation
- Pass comprehensive context between phases
- Only interrupt for critical decisions
- Document all assumptions clearly
- Ensure the PRD enables successful one-shot implementation

## Parallelization Guidelines
- Identify independent tasks within each phase
- Launch multiple agents simultaneously when they don't depend on each other
- Use clear, specific prompts for each parallel agent
- Consolidate results before moving to the next phase
- Example: In Phase 2, you might launch 3-5 research agents in parallel to investigate different technical areas

## Research Decomposition Guidelines
When identifying research areas in Phase 2, consider:
- **Technical layers**: Frontend, backend, database, infrastructure
- **Feature aspects**: Core logic, integrations, security, performance
- **Cross-cutting concerns**: Logging, monitoring, error handling
- **Dependencies**: External services, libraries, APIs

Aim for 3-7 focused research areas for most features. Each researcher should have:
- Clear scope and boundaries
- Specific questions to answer
- Relevant subset of requirements
- No overlap with other researchers

## Expected Outputs
1. Comprehensive PRD in docs/features/[XXX]-[feature-name].md
2. Pattern documentation in docs/patterns/
3. Interface specifications in docs/interfaces/
4. Clear confidence assessment
5. Documentation of any assumptions or pending decisions
