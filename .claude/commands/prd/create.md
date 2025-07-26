---
description: Create a comprehensive Product Requirement Document from a brief description
allowed-tools:
  - LS
  - Glob
  - Grep
  - Read
  - Write(docs/**)
  - Task
  - WebSearch
  - WebFetch
  - MultiEdit(docs/**)
  - Edit(docs/**)
  - TodoWrite
argument-hint: <feature description>
---

# Create PRD Command

## Overview
Creates a comprehensive PRD that enables one-shot implementation by:
- Gathering complete requirements through clarification
- Researching codebase patterns via parallel agents
- Documenting patterns, interfaces, and specifications
- Following ~/.claude/templates/prd.md structure

## Process

### 1. Requirements Clarification
**Feature**: $ARGUMENTS

Ask clarifying questions about:
- Core functionality and user workflows
- Technical requirements and constraints
- UI/UX expectations
- Business context and user personas
- Scope boundaries and future extensibility

**Wait for user response before proceeding to research phase.**

Note: Only proceed with defaults if user explicitly says to continue.

### 2. Launch Parallel Research Agents

**Dynamic Research Strategy**:
Based on the feature requirements, spawn multiple Task agents in parallel to comprehensively research the codebase.

**Common Research Agents** (spawn as needed):

1. **Core Architecture Agent**
   - App structure, data models, internal APIs
   - Database schemas and relationships
   - Existing similar features

2. **Integration Discovery Agent**
   - External services and third-party APIs
   - Authentication and authorization patterns
   - API contracts and data formats

3. **Testing Strategy Agent**  
   - Test utilities and helpers
   - Mock patterns and test data factories
   - Testing approaches and coverage requirements

4. **Build & Configuration Agent**
   - Project setup and dependencies
   - Build/lint/test commands
   - Development workflow

5. **UI/Component Agent** (if UI involved)
   - Component patterns and structure
   - State management approaches
   - User interaction flows

**Agent Instructions**:
```
Your task: Research [specific area] for [feature name]

Deep dive into all aspects of [area]. Extract:
- Actual code examples and patterns
- Relevant files and their purposes
- How similar features are implemented
- Any external services or APIs involved
- Common pitfalls and best practices

Note whether findings relate to:
- Internal application code/data
- External service integrations
- Reusable patterns or approaches

Return comprehensive findings to enable one-shot implementation.
```

**Remember**: Agents should use ALL available tools - search the codebase, read files, search the web for documentation, and gather everything needed for implementation success.

### 3. Architecture Decision Points

**After research, if critical decisions are needed:**

Present to user:
```
## Architecture Decision Required

### Decision: [Title]
**Context**: [Why this decision is needed]

**Options**:
1. **Option A**: [Description]
   - Pros: [Benefits]
   - Cons: [Drawbacks]

2. **Option B**: [Description]
   - Pros: [Benefits]
   - Cons: [Drawbacks]

**Recommendation**: [Your suggested approach and why]

Please choose an option or provide alternative direction.
```

**Important**:
- Only interrupt for decisions that significantly impact implementation
- Present all pending decisions at once
- If no response, document as "Pending Decision" in PRD

### 4. Document Generation

Based on research findings, create:

**docs/patterns/** - Reusable approaches:
- Architectural patterns (auth-flow.md, state-management.md)
- Error handling (retry-logic.md, fallback-patterns.md)
- Testing approaches (test-structure.md, mock-strategies.md)

**docs/interfaces/** - Third-party specifications:
- API contracts (stripe-api.md, auth0-api.md)
- Webhook schemas (payment-webhooks.md)
- Integration requirements (oauth-flow.md)

### 5. PRD Creation
- Generate feature ID: Check existing files in docs/features/, use next 3-digit number
- Read and follow ~/.claude/templates/prd.md structure exactly
- Include ONLY internal changes in the PRD (database, internal APIs, models)
- Reference external docs in Integration Points section
- Reference pattern docs in Context Assembly section
- Write directly to: docs/features/[001]-[feature-title].md

### 6. Final Validation

Before creating files, if critical gaps remain:
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

### 7. Confidence Assessment
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

## Key Principles
- Always wait for user response after initial clarifications
- Only interrupt research for critical architecture decisions
- Document all assumptions and pending decisions in PRD
- Provide clear options when user input is needed
- Batch decision points to minimize interruptions
