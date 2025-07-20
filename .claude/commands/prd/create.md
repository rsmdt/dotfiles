---
description: Create a comprehensive Product Requirement Document from a brief description
allowed-tools:
  - LS
  - Glob
  - Grep
  - Read
  - Write(docs/patterns/**)
  - Write(docs/features/**)
  - Task
  - WebSearch
  - WebFetch
  - MultiEdit(docs/patterns/**)
  - MultiEdit(docs/features/**)
  - Edit(docs/patterns/**)
  - Edit(docs/features/**)
  - TodoWrite
argument-hint: <feature description>
---

# Create Comprehensive PRD from Feature Description

## Initial Feature Analysis

Before creating the PRD, I need to understand the feature requirements in detail.

### Feature Request: **$ARGUMENTS**

Let me ask clarifying questions to ensure the PRD captures all necessary requirements and avoids assumptions:

1. **Core Functionality**
   - What specific user actions or workflows should this feature support?
   - Are there any existing features this should integrate with or replace?
   - What are the primary use cases and user scenarios?

2. **Technical Requirements**
   - Are there specific performance requirements or constraints?
   - Should this work across specific platforms/browsers/devices?
   - Are there any third-party integrations required?

3. **User Experience**
   - What should the user interface look like? (Layout preferences, visual style)
   - Are there specific interaction patterns to follow or avoid?
   - How should errors or edge cases be handled from the user's perspective?

4. **Business Context**
   - Who are the primary users of this feature?
   - What business problem does this solve?
   - Are there any compliance or security requirements?

5. **Scope and Constraints**
   - What's explicitly out of scope for this feature?
   - Are there any timeline or resource constraints to consider?
   - Should this be built for future extensibility in any particular direction?

Please provide additional details for any of these areas. If you'd like me to proceed with reasonable defaults based on common patterns in the codebase, I can do that, but the more context you provide, the more accurate and useful the PRD will be.

**Note**: After receiving your clarifications, I'll create comprehensive documentation including:
- Pattern files in `docs/patterns/` for reusable architectural decisions
- A detailed PRD in `docs/features/` following the standard template
- Complete implementation guidance for one-shot development

**⚠️ IMPORTANT: Direct File Creation**
Once we've clarified the requirements, I'll create files directly without asking for confirmation. Write access is restricted to docs/patterns/** and docs/features/** only.

---

## After Receiving Clarifications

Once you've provided additional details, I'll proceed with the comprehensive PRD creation process below:

## 🎯 Primary Goal: Enable One-Shot Implementation

Your PRD must contain **ALL** necessary context, examples, patterns, and specifications to allow another AI agent to implement the feature in a single session without needing additional research or clarification. 

**Success means**: The execute command can read your PRD and implement the feature completely without asking questions or searching for missing information.

## Critical Requirements

1. **Thorough Research**: Use multiple parallel agents to explore the codebase comprehensively
2. **Pattern Documentation**: Create reusable pattern files in `docs/patterns/`
3. **Complete Context**: Include all discovered context and file references
4. **Template Compliance**: Follow `~/.claude/templates/prd.md` structure exactly
5. **Direct File Creation**: Create files immediately without asking for confirmation

## Process Overview

### Phase 1: Deep Codebase Analysis
Launch multiple parallel agents to:
- Analyze project structure and architecture
- Find all similar features and implementations
- Discover UI patterns and component usage
- Identify data flow and state management patterns
- Extract testing and validation approaches
- Document build and development workflows

### Phase 2: Pattern Extraction
Create or update files in `docs/patterns/` for discovered patterns:
- Architectural patterns (e.g., `auth-flow.md`, `state-management.md`)
- UI conventions (e.g., `component-structure.md`, `styling-patterns.md`)
- Integration patterns (e.g., `api-client-usage.md`, `hook-composition.md`)
- Testing patterns (e.g., `test-structure.md`, `mock-strategies.md`)

Focus on stable, reusable patterns - not implementation details that change frequently.

### Phase 3: PRD Generation
Generate the PRD following `~/.claude/templates/prd.md` with these critical enhancements:

#### 1. Frontmatter (Add at top)
```yaml
---
prd_version: 1.0
feature_id: [3-digit-number]
feature_title: [kebab-case-feature-name]
estimated_complexity: [low|medium|high]
confidence_score: [percentage]
confidence_summary: "[Brief explanation of confidence level]"
pending_decisions: "[List key decisions needing user input, or 'none']"
implemented_at: null
---
```

#### 2. Project Commands (Add after Constraints)
```markdown
### Project Commands and Scripts
- Lint: `[discovered lint command]`
- Type check: `[discovered typecheck command]`
- Test: `[discovered test command]`
- Build: `[discovered build command]`
```


#### 3. Enhanced Anti-Patterns Section
Merge with existing anti-patterns in a single section:
```markdown
## Anti-Patterns to Avoid

### General Anti-Patterns
- ❌ Don't create new patterns when existing ones work
- ❌ Don't skip validation because "it should work"
- ❌ Don't ignore failing tests - fix them
- ❌ Don't hardcode values that should be config
- ❌ Don't catch all exceptions - be specific

### Implementation-Specific
- ❌ Creating new files when existing ones can be extended
- ❌ Adding dependencies without checking if functionality exists
- ❌ Modifying unrelated code sections
- ❌ Making architectural changes without user validation
```

#### 4. Pattern References
In the Context and Scope section, reference all relevant pattern files:
```yaml
- doc: docs/patterns/[pattern-file].md
  why: [How this pattern applies to the feature]
```

## Execution Instructions

### Step 1: Parse Feature Request
Understand "$ARGUMENTS" and identify:
- Extract feature ID if provided (e.g., "#001" format)
- If no ID provided, scan `docs/features/` for existing files and use next available 3-digit number
- Generate kebab-case feature title from the description
- Feature type and scope
- Affected system areas
- Required capabilities

**Critical**: Parse ALL requirements from the user input, especially:
- Layout requirements (full-screen, sidebar, etc.)
- Migration requirements (from/to what)
- Specific constraints mentioned

### Step 2: Launch Parallel Research Agents
Based on the feature requirements identified in Step 1, spawn multiple Task agents to comprehensively research the codebase. 

**Dynamic Agent Strategy**:
- Analyze the feature type and requirements
- Spawn specialized agents for each relevant aspect
- Call multiple Task tools in a single message for efficiency

**Common Research Areas** (spawn agents as needed):
- **UI/Component patterns** - If feature involves UI changes
- **Data flow and state** - If feature handles data or state
- **Routing/Navigation** - If feature adds/modifies routes
- **API/Backend integration** - If feature interacts with backend
- **Testing approaches** - Always needed (discover test utilities, mock patterns, test data factories)
- **Build/Configuration** - Always needed for project setup
- **Security/Auth patterns** - If feature touches protected resources
- **Performance patterns** - If feature has performance implications
- **Error handling** - If feature has complex error scenarios

**Agent Instructions**:
Each agent should:
- Deep dive into its specific area
- Extract actual code examples and patterns
- Identify relevant files and dependencies  
- Note common pitfalls and best practices
- Return comprehensive findings

**Testing Agent Special Instructions**:
- Find test utility files (test-utils.ts, setup files)
- Identify mock factories and test data builders
- Extract testing patterns (how components are rendered, how async is handled)
- Note testing libraries and their usage patterns
- Find examples of good tests that verify behavior, not just existence

**Remember**: The goal is to gather EVERYTHING needed for one-shot implementation. When in doubt, gather more context rather than less.

**Example**: For a "story detail page" feature, you might spawn agents for:
- UI patterns (how are detail pages structured?)
- Routing patterns (how are dynamic routes implemented?)
- Data fetching (how are individual resources loaded?)
- Layout patterns (full-screen vs sidebar layouts)
- Navigation patterns (breadcrumbs, back buttons)

The exact agents spawned should match the feature's needs.

### Step 3: Consolidate Research Findings
After all agents return:
1. Synthesize findings from all parallel agents
2. Identify common patterns and architectural decisions
3. Note any conflicting information that needs clarification
4. Identify any pending architecture decisions that need user input

**Progress Reporting**:
Provide status updates in chat:
```
📊 PRD Creation Progress:
✅ Feature analysis complete
✅ Codebase research complete (X agents)
🔄 Documenting patterns...
⏳ Generating PRD
```

### Step 4: Interactive Architecture Decisions
If there are architecture decisions that could significantly impact implementation:

**Present to User**:
```
## Architecture Decision Required

### Decision: [Decision Title]
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
- Only interrupt for decisions that would change the implementation approach
- Present all pending decisions at once to minimize interruptions
- If no response, document the pending decision in the PRD

### Step 5: Document Patterns
For each discovered pattern:
1. Check if `docs/patterns/[pattern].md` exists
2. Create new file or update existing with findings using Write/Edit tools
3. Focus on architectural decisions and stable patterns
4. Create `docs/patterns/` directory if it doesn't exist

**IMPORTANT: Direct File Writing**:
- Use the Write tool directly without asking for confirmation
- Files can only be created in:
  - `docs/patterns/**` for reusable patterns
  - `docs/features/**` for the PRD itself
- The Write tool will create directories automatically if needed

### Step 6: Generate Comprehensive PRD
1. Read and follow `~/.claude/templates/prd.md` structure
2. Fill every section with discovered context
3. Include all relevant file references with specific reasons
4. Reference all applicable `docs/patterns/` files
5. Add discovered project commands
6. In the Cross-Cutting Concepts section, add Implementation Patterns:
   - Common import patterns with actual paths
   - Component structure examples (skeleton only)
   - Error handling patterns used in the codebase
7. In the Cross-Cutting Concepts section, add Implementation Hints:
   - Suggested starting point
   - Key patterns to follow
   - Common pitfalls discovered
8. For complex features, include pseudocode in Runtime View
9. Ensure test specifications are meaningful:
   - Use 3-part structure: Setup, Action, Assert
   - Test actual behavior, not just code existence
   - Include specific mock data and expected outcomes
   - Cover user interactions, async operations, error states
   - Example: "test('renders story content')" should verify DOM elements exist, not just that a component is defined
10. Ensure implementation checklist is detailed and complete

### Step 7: Validate PRD Completeness
Verify the PRD contains:
- [ ] All necessary file references with clear reasons
- [ ] Implementation patterns with code examples
- [ ] Complete implementation checklist with consistent heading levels
- [ ] Clear, measurable success criteria
- [ ] Project-specific validation commands (generic, not path-specific)
- [ ] All discovered patterns referenced
- [ ] Anti-patterns in single consolidated section
- [ ] Test specifications with concrete behavior verification (not just existence checks)
- [ ] Test utilities and mock patterns from codebase included
- [ ] Implementation hints without over-constraining
- [ ] Pseudocode for complex logic (if applicable)

**Quality Checks**:
- [ ] No assumptions about cross-user functionality in authenticated apps
- [ ] No SEO considerations for authenticated routes
- [ ] Performance targets are realistic and measurable
- [ ] Any architectural changes are flagged as "needs user validation"
- [ ] All user requirements from input are addressed

### Step 8: Final User Clarification
Only if critical information is missing after thorough research:
- Present findings and gaps
- Ask specific, targeted questions
- Suggest reasonable defaults based on codebase patterns

## Output

### 1. Create PRD
Write the PRD directly to: `docs/features/[3-digit-id]-[feature-title].md`

Example filenames:
- `docs/features/001-dark-mode-toggle.md`
- `docs/features/002-user-authentication.md`
- `docs/features/015-story-detail-page.md`

**Direct File Creation**:
- Use the Write tool immediately without confirmation
- Write the complete PRD in one operation
- Location must be `docs/features/[3-digit-id]-[feature-title].md`

### 2. Provide Confidence Rating
After creating the PRD, provide an assessment:

```
## One-Shot Implementation Confidence Rating: [X]%

### Confidence Factors:
✅ **High Confidence Factors:**
- [List what makes you confident about one-shot success]
- [e.g., Clear patterns found, all dependencies identified]

⚠️ **Risk Factors:**
- [List what might cause implementation to fail or need clarification]
- [e.g., Complex state management, unclear performance requirements]

### Missing Information:
- [List any gaps that could block implementation]
- [Suggest how to address these gaps]

### Recommendation:
[State whether the PRD is ready for one-shot implementation or needs user clarification on specific points]
```

The PRD must be so comprehensive that implementation can succeed without additional context gathering. Be honest in your confidence assessment.

## Important Notes

- Use parallel agents liberally - comprehensive research is critical
- Every file reference must include a specific reason why it's relevant
- Code examples should guide but not constrain - show patterns, not full implementations
- Test cases should describe behavior, not implementation details
- Keep validation commands generic to the project (test commands, not specific paths)
- The PRD should enable autonomous implementation without manual validation steps
- Include pseudocode for complex algorithms or business logic
- Document any assumptions made during research

## Feature ID Generation

1. Check if feature ID is provided in arguments (format: #001, #002, etc.)
2. If not provided:
   - List all files in `docs/features/` directory
   - Extract existing IDs from filenames (format: 001-feature-name.md)
   - Use the next sequential 3-digit number
   - If directory is empty or doesn't exist, start with 001
3. Always format as 3 digits with leading zeros (001, 002, ... 099, 100, etc.)

## Key Principles

1. **Completeness**: Provide ALL context needed for one-shot implementation success
2. **Examples over Instructions**: Show code patterns rather than describing them
3. **Automation**: All validation must be executable via commands, not manual testing
4. **Balance**: Give enough detail without over-constraining implementation choices
5. **Honest Assessment**: Provide realistic confidence ratings, flagging any gaps

**Goal**: Create a PRD comprehensive enough for the execute command to implement the feature without additional research or questions.

Begin comprehensive codebase analysis using parallel agents.
