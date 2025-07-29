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
argument-hint: <feature description>
---

# Create PRD Command

## Overview
Creates a comprehensive PRD that enables one-shot implementation by:
- Gathering complete requirements through clarification
- Researching codebase patterns via parallel agents
- Documenting patterns, interfaces, and specifications
- Following @~/.claude/templates/prd.md structure

## Process

### 1. Requirements Clarification
**Feature**: $ARGUMENTS

**Dynamic Analysis Phase**:
Analyze the feature request to identify what information is needed for a complete implementation. Based on the feature type and complexity, ask targeted questions about the specific aspects that need clarification.

Analyze the feature and generate relevant questions based on:
- Feature domain and technical context
- Integration points and dependencies  
- User interaction requirements
- Data and state management needs
- Performance and scaling considerations
- Security and compliance requirements

**Wait for user response before proceeding to research phase.**

Note: Only proceed with defaults if user explicitly says to continue.

### 2. Launch Parallel Research Agents

**Dynamic Research Strategy**:
Based on the analyzed requirements, determine which research agents are needed and spawn them in parallel.

**Agent Generation Process**:
1. Analyze feature requirements to identify research areas
2. Create specialized agents for each identified area
3. Ensure agents leverage all available tools including MCP servers
4. Launch agents in parallel for efficiency

**Generic Agent Template**:
```
Research Agent: [Dynamic Area Name]
Task: Research [specific aspect] for [feature name]

Investigate all aspects of [area] including:
- Code patterns and implementations
- Integration points and dependencies
- External services and APIs
- Configuration and environment needs

CRITICAL: Use ALL available tools:
- Search and read codebase files
- Use MCP servers for external services
- Search web documentation
- Analyze database schemas
- Check build/test configurations

Focus on gathering actionable implementation details.
Return comprehensive findings with specific file references and code examples.
```

**MCP Tool Priority**:
When researching external integrations, prioritize MCP tools for:
- Database operations (use database MCPs)
- API interactions (use service-specific MCPs)
- Configuration management (use config MCPs)
- Development workflows (use dev tool MCPs)
- Browser automation (use Playwright MCP)
- Any other domain-specific MCPs available

**Dynamic Area Discovery Examples**:
Based on the feature, identify areas such as:
- Authentication & authorization flows
- Data persistence and migration strategies
- Third-party service integrations
- User interface components and interactions
- Background job processing
- Real-time communication (WebSockets, SSE)
- File handling and storage
- Performance optimization needs
- Security and compliance requirements
- Internationalization and localization
- Analytics and monitoring integration
- And any other relevant technical domains

**Remember**: Analyze the specific feature to determine exactly which research areas are relevant, rather than following a predefined checklist.

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
- Read and follow @~/.claude/templates/prd.md structure exactly
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
